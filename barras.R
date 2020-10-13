
library(rvest)
library(tidyr)
library(dplyr)
library(ggplot2)

img <- png::readPNG("data/logo.png")
rast <- grid::rasterGrob(img, interpolate = T)

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

df %>% arrange(season) %>% mutate(id = row_number()) %>% 
  ggplot(aes(x=reorder(Title,-id),y=as.numeric(viewers), group=1,fill=as.factor(season)))+
  geom_col()+  
  geom_line(color="green", size=1)+
  coord_flip()+
  annotation_custom(rast, ymin = 1.2, ymax = 1.9, xmin =-40) +
  geom_curve(aes(x = 29, y = 1.5, xend = 24, yend = 0.9),
             arrow = arrow(length = unit(0.07, "inch")), 
             size = 0.2, color = "white", curvature =-0.2)  +
  annotate("text", x = 30, y = 1.5, size = 4, color = "white",
           label = "(no vean el nombre de este episodio)") +
  scale_fill_manual(values = c("#996f6d", "#995451", "#99342f",'#990700'))+
  labs(x="",y='Audiencia (millones de espectadores)',
       title="Audiencia de Mr Robot", 
       caption="#30diasdegraficos, una iniciativa de @R4DS_es, @karbartolome")+
  scale_y_continuous(expand = c(0, 0), limits = c(0, 2.3))+
  theme_bw()+
  theme(panel.background = element_rect(fill='#121F1F'), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        title=element_text(color="white"),
        panel.grid = element_blank(), 
        axis.line = element_line(color="white"),
        plot.background = element_rect(fill='#121F1F'), 
        axis.text = element_text(color='white'), 
        legend.position = 'none')
