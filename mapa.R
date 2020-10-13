library(leaflet)

style_label=list(
  "color" = "red",
  "background-color" = "white",
  "font-family" = "courier",
  "font-style" = "bold",
  "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
  "font-size" = "12px",
  "border-color" = "grey"
)

leaflet() %>%
  addProviderTiles('Esri.WorldGrayCanvas') %>%
  #addProviderTiles('Stamen.TonerBackground') %>% 
  addControl('#30diasdegraficos, una iniciativa de @R4DS_es, @karbartolome',
             position = "bottomright") %>%
  # Departamento de elliot
  addMarkers(lat = 40.7142482, lng = -73.9873578,
             icon = makeIcon(
               iconUrl = "https://www.themarysue.com/wp-content/uploads/2015/08/Robot2.jpg",
               iconWidth = 800 / 13,
               iconHeight = 532 / 13),
             label = "Departamento de Elliot",
             labelOptions = labelOptions(noHide = T, direction = "top", offset = c(0, -20),style = style_label)
  ) %>%
  # FSociety
  addMarkers(lat = 40.57508, lng = -73.9823909,
             icon = makeIcon(
               iconUrl = "https://www.oohlo.com/wp-content/uploads/2016/07/vlcsnap-2016-07-22-18h42m43s841.png",
               iconWidth = 720 / 10,
               iconHeight = 418 / 10),
             label = "FSociety",
             labelOptions = labelOptions(noHide = T,direction = "top",offset = c(0, -20),style = style_label)
  ) %>%
  # Ecorp
  addMarkers(lat = 40.7611542, lng = -73.9692152,
             icon = makeIcon(
               iconUrl = "https://www.welivesecurity.com/wp-content/uploads/2017/11/mrrobot_302.jpg",
               iconWidth = 677 / 9,
               iconHeight = 381 / 9),
             label = "E-corp",
             labelOptions = labelOptions(noHide = T,direction = "top",offset = c(0, -20),style = style_label)
  ) %>%
  # Primer encuentro Elliot y Mr Robot
  addMarkers(lat = 40.6508541,lng = -73.9507892,
             icon = makeIcon(
               iconUrl = "https://geekyapar.com/wp-content/uploads/2015/08/robot_mediagallery_whiterose_subway.jpg",
               iconWidth = 820 / 15,
               iconHeight = 820 / 15),
             label = 'Primer encuentro con Mr Robot',
             labelOptions = labelOptions(noHide = T, direction = "top", offset = c(0, -20),style = style_label)
  )  %>%
  # Logo
  addMarkers(lat = 40.55,lng = -73.8,
             icon = makeIcon(
               iconUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Mr._Robot_Logo.svg/1985px-Mr._Robot_Logo.svg.png",
               iconWidth = 1985 / 10,
               iconHeight = 393 / 10) 
  )
