rm(list=ls())

library(rvest)
library(tidyr)
library(dplyr)
library(ggplot2)
library(extrafont)

# Wikipedia
html = read_html('https://en.wikipedia.org/wiki/List_of_Mr._Robot_episodes#Ratings')

xpaths=data.frame()
for (i in list(7:10)) {
  xpath= paste0('//*[@id="mw-content-text"]/div/table[',i,"]")
  xpaths=rbind(xpaths,data.frame(xpath,stringsAsFactors = FALSE))}

df=data.frame(stringsAsFactors = FALSE)
for (i in 1:4) {
  webpage_table = html %>% 
    html_nodes(xpath= xpaths$xpath[i]) %>% 
    html_table()
  webpage_table = data.frame(webpage_table,stringsAsFactors = FALSE)
  webpage_table$season=i
  df=rbind(webpage_table,df)
}

df=separate(data = df, col = Viewers.millions., into = c("viewers", "remove"), sep='\\[') %>% select(-remove)
df$Title=gsub('"','',df$Title)
df=df %>% arrange(season) %>% mutate(id = row_number())

# Angles
label_data <- df
number_of_bar <- nrow(label_data)
angle <-  90 - 360 * (label_data$id-0.5) /number_of_bar 
label_data$hjust<-ifelse( angle < -90, 1, 0)
label_data$angle<-ifelse(angle < -90, angle+180, angle)

# Coordpolar
ggplot(df, aes(x=as.factor(id), y=as.numeric(viewers))) +
    geom_col(aes(fill=as.factor(season))) +
    coord_polar(start = 0) +
    geom_text(data=label_data, aes(x=id, 
                                 y=as.numeric(viewers)+0.4, 
                                 label=paste(Title), 
                                 hjust=hjust), 
            color="black", fontface="bold",alpha=0.6, size=3, 
            angle= label_data$angle) +
    geom_text(data=label_data, aes(x=id, 
                                 y=as.numeric(viewers)+0.1, 
                                 label=paste0(round(as.numeric(viewers),1),"M"), 
                                 hjust=hjust), 
            color="red", fontface="bold",alpha=0.6, size=2, 
            angle= label_data$angle) +
    ylim(0,3) +
    scale_fill_manual(values = c("#325c38", "#5b8f65","#87c595","#b5ffc9"))+
    labs(fill='Temporada', 
         title='Audiencia de Mr Robot',
         caption='#30diasdegraficos, una iniciativa de @R4DS_es, @karbartolome')+
    theme_minimal() +
    theme(
      axis.text = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      text=element_text(size=20,  family="Andale Mono"),
      legend.direction = 'horizontal',
      legend.position = c(0.5,0.1),
      plot.title=element_text(hjust=0.5)
    )

