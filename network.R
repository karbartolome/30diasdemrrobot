# Liberías
library(dplyr)
library(visNetwork)

# Data
df = read.csv('data/mr_robot_red_fbi.csv',stringsAsFactors = FALSE, sep=";")

# Visnetwork --------------------------------------------------------------
nodes = data.frame(id = unique(rbind(data.frame(id=df$from, stringsAsFactors = FALSE),
                                     data.frame(id=df$to, stringsAsFactors = FALSE))))
                            
nodes$title = nodes$id
values = df %>% 
  group_by(from, image) %>% 
  summarise(value=n()) %>% 
  ungroup()

nodes = merge(nodes, values, by.x='id', by.y='from')
nodes$shape = c('image')
edges = df %>% select(from, to)

graph=visNetwork(nodes, edges, main='Conexiones en Mr Robot según el FBI', submain='#30diasdegraficos, una iniciativa de @R4DS_es, @karbartolome') %>% 
  visOptions(highlightNearest = TRUE, 
             nodesIdSelection = FALSE, 
             width = 1000, height = 600) %>% 
  visEdges(arrows='to', 
           color='#8f3131', 
           smooth=list('type'='cubicBezier')) %>% 
  visNodes(font=list('background'='white'))

graph

visSave(graph, 'mrrobot_network.html', selfcontained = TRUE, background = "white")
