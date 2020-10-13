rm(list=ls())

library(packcircles)
library(ggplot2)
library(dplyr)
library(tidyr)
library(rvest)

img <- png::readPNG("data/logo.png")
rast <- grid::rasterGrob(img, interpolate = T)
html = read_html('https://www.imdb.com/title/tt4158110/fullcredits')

webpage_table = html %>%
  html_nodes('.cast_list') %>%
  html_table()

webpage_table = data.frame(webpage_table, stringsAsFactors = FALSE)

df = webpage_table %>% select(-X1, -X3) %>% filter(X2 != "")
df$X4 = gsub("          ", "--", df$X4)
df$X4 = gsub("/ ...", "", df$X4)
df = separate(data = df,col = X4,into = c("Personaje", "Aparicciones"),sep = "--")
df$episodios = sub("^\\D*(\\d+).*$", "\\1", df$Aparicciones)
df = separate(data = df,col = Aparicciones,into = c("remove", "años"),sep = ",")
df$text=paste(df$Personaje,"\n ",df$años)

packing <- circleProgressiveLayout(df$episodios, sizetype = 'area')
data <- cbind(df, packing)
bubbles_df <- circleLayoutVertices(packing, npoints = 50)

ggplot() +
  geom_polygon(
    data = bubbles_df,
    aes(x,y,group = id,fill = as.numeric(id)),
    colour = "#121F1F",alpha = 1) +
  geom_text(data = data, 
            aes(x, y, size = as.numeric(episodios), label = Personaje, 
                text=paste('Personaje: ',Personaje, 
                           'Actor: ', X2
            )), 
            color='red') +
  annotation_custom(rast, ymin = -25, ymax=-19, xmin =14,xmax=23) +
  scale_fill_gradient2(low='white',high='black')+
  scale_size_continuous(range = c(1, 2)) +
  labs(title='Personajes de Mr Robot con más aparicciones', 
       caption="#30diasdegraficos, una iniciativa de @R4DS_es, @karbartolome")+
  coord_equal()+
  theme(legend.position = "none", 
        panel.background = element_rect(fill='white'), 
        plot.background =  element_rect(fill='white'),
        plot.title = element_text(hjust = 0.5, color='black', size=10, vjust=-2), 
        plot.caption = element_text(color='black'), 
        panel.border = element_blank(), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), 
        axis.title = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(), 
        axis.text = element_blank())
