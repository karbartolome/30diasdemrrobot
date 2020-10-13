rm(list=ls())

library(rvest)
library(dplyr)
library(tidyr)
library(janitor)
library(ggplot2)
library(extrafont)
#font_import()
#loadfonts(device = "win", quiet = TRUE)

img <- png::readPNG("data/logo.png")
rast <- grid::rasterGrob(img, interpolate = T)

# Imdb scraping
html = read_html('https://www.imdb.com/title/tt4158110/ratings?ref_=tturv_ql_4')

# Dataframe
df = html %>%
  html_nodes(xpath = '//*[@id="main"]/section/div/table[2]') %>%
  html_table()
df=data.frame(df[[1]])

df = clean_names(df)
rownames=df$var_1
df=df %>% dplyr::select(-var_1)

df=df %>% separate(x_18, c("rat18", "cant18"), "\n            \n                \n                    ")
df=df %>% separate(x18_29, c("rat1829", "cant1829"), "\n            \n                \n                    ")
df=df %>% separate(x30_44, c("rat3044", "cant3044"), "\n            \n                \n                    ")
df=df %>% separate(x45, c("rat45", "cant45"), "\n            \n                \n                    ")

df_rating =df %>% dplyr::select(starts_with("rat"))
df_rating$tipo=rownames
df_rating=df_rating %>% 
  mutate_if(is.character,as.numeric) %>% 
  gather(key='tipo',value='value')  %>% 
  mutate(genero=rep(rownames,4), 
         indicador='Rating')

df_count =df %>% dplyr::select(starts_with("cant"))
df_count=data.frame(sapply(df_count, function(x) as.numeric(gsub(",", "", x))))
df_count$tipo=rownames

df_count=df_count %>% 
  gather(key='tipo',value='value') %>% 
  mutate(genero=rep(rownames,4), 
         indicador='Cantidad')

df=rbind(df_rating,df_count)
df %>% 
  mutate(tipo=factor(case_when(
                 tipo=='rat18' ~ '<18', 
                 tipo=='rat1829' ~ '18-29',
                 tipo=='rat3044' ~ '30-44',
                 tipo=='rat45' ~ '>45', 
                 tipo=='cant18' ~ '<18 ', 
                 tipo=='cant1829' ~ '18-29 ',
                 tipo=='cant3044' ~ '30-44 ',
                 tipo=='cant45' ~ '>45 '), 
                 levels=c('<18','18-29','30-44','>45', '<18 ','18-29 ','30-44 ','>45 '))
  ) %>% 
  ggplot+
      geom_point(aes(x=tipo,y=value,color=genero,group=genero), size=5, alpha=0.7)+
      geom_line(aes(x=tipo,y=value,color=genero,group=genero), size=3, alpha=0.5, show.legend = FALSE)+
      facet_wrap(~indicador,scales='free', nrow=2) +
      theme_bw()+
      scale_color_manual(values = c('black',"#269757", "#b43131"))+
      labs(x="",y="", color='Género',
           title='Mr Robot - Ratings según edad y género', 
           caption='#30diasdegraficos, una iniciativa de @R4DS_es, @karbartolome')+
      theme(text=element_text(size=20,  family=".New York"), 
            panel.grid.major = element_blank(), 
            panel.border = element_blank(),
            axis.ticks = element_blank(),
            plot.title = element_text(hjust = 0.5),
            plot.caption.position = 'plot',
            strip.background = element_rect(color="black", fill="#f5f5f5", size=0, linetype="solid")
            )
    







