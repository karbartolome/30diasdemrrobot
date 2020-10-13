library(rvest)
library(dplyr)
library(circlize)

# Wikipedia
html = read_html('https://en.wikipedia.org/wiki/Golden_Globe_Award_for_Best_Television_Series_%E2%80%93_Drama')

# Dataframe
df = data.frame(html %>% 
  html_nodes(xpath= '//*[@id="mw-content-text"]/div/table[7]') %>% 
  html_table()) %>% 
  select(-Network) %>%  
  mutate(Program=ifelse(Program=='Mr. Robot','Mr Robot',Program))

df$winner=winner=rep(c(1,0,0,0,0),5)
df$winner=ifelse(df$winner==1,'Ganó','No ganó')

adjacencyData <- with(df %>% filter(Year>=2015), table(Year, Program))

# Colores 
grid.col=c('#54001f',  '#541942',  '#44305f',  '#27446f',  '#005473','red',rep('black',17))
names(grid.col)=c('2015','2016','2017','2018','2019',"Mr Robot", 
                  unique(df%>% filter(Year>=2015 & Program!='Mr Robot') %>% pull(Program)))

# Chorddiagram
chordDiagram(adjacencyData, 
             annotationTrack = c("grid"), 
             preAllocateTracks = 1,
             big.gap = 20,
             grid.col = grid.col, 
             grid.border = NA)

circos.trackPlotRegion(track.index = 1, panel.fun = function(x, y) {
  xlim = get.cell.meta.data("xlim")
  ylim = get.cell.meta.data("ylim")
  sector.name = get.cell.meta.data("sector.index")
  circos.text(mean(xlim), ylim[1] + .1, sector.name, facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5))
}, bg.border = NA)

title(main = "Golden Globe Award - Nominaciones a Mejor serie dramática desde 2015", 
      line=-43, adj = 0.5, cex.main=2)
title(main = "#30diasdegraficos, una iniciativa de @R4DS_es, @karbartolome", 
      line=-45, adj = 0.5, cex.main=1)

dev.off()
