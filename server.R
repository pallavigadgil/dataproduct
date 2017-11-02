#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(zipcode)
library(leaflet)
library(data.table)
library(plotly)
data("zipcode")

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  # create a reactive value that will store the click position
 
      snowdf <- read.csv("snowdata_new.csv")
      snowdf$lat <- zipcode$latitude[match(snowdf$Zip, zipcode$zip)]
      snowdf$long <- zipcode$longitude[match(snowdf$Zip, zipcode$zip)]
      mapsnowdf <- snowdf[complete.cases(snowdf),]
      mapsnowdf <-  mapsnowdf[mapsnowdf$Annual>50,]
      
      data_of_click <- reactiveValues(clickedMarker=NULL)
      
  # build data with 2 places

  
  
  # Leaflet map with 2 markers
  output$map <- renderLeaflet({
        snowmaps <- data.frame(
      lat =   mapsnowdf$lat ,
      lng =  mapsnowdf$long)
   
      leaflet(snowmaps) %>%
        addTiles() %>%
      addMarkers(popup=mapsnowdf$City, layerId = mapsnowdf$Zip)

   ## leaflet() %>% 
    ##  setView(lng=131 , lat =-25, zoom=4) %>%
     ## addTiles(options = providerTileOptions(noWrap = TRUE)) %>%
      ##addCircleMarkers(data=mapsnowdf, ~x , ~y, layerId=~, popup=~id, radius=8 , color="black",  fillColor="red", stroke = TRUE, fillOpacity = 0.8)
  })
  
  # store the click
  observeEvent(input$map_marker_click,{
    data_of_click$clickedMarker <- input$map_marker_click
    print(data_of_click$clickedMarker$id)
    # if((is.null(input$map_marker_click)))
    #   return()
    # print(input$map_marker_click$id)
    # lat <- input$map_marker_click$lat
    # lon <- input$map_marker_click$lng
    # zip <- input$map_marker_click$id
    
    #annualDf <- mapsnowdf[ which(mapsnowdf$lat==lat & mapsnowdf$long==lon), 5:16 ]
  
   
})
  
 output$text=renderText({
if(is.null(data_of_click$clickedMarker$id))
  return()
   zip <- data_of_click$clickedMarker$id
   title <- paste("Annual Snow Accumulations for " , mapsnowdf[ which(mapsnowdf$Zip==zipcode),2],":",mapsnowdf[ which(mapsnowdf$Zip==zipcode),17],"inches",sep=" ")
   print("title")
   print(title)
 }
   
 )
  # Make a barplot or scatterplot depending of the selected point
  output$plot=renderPlotly({
    zip <- data_of_click$clickedMarker$id
    print(zip)
    if(is.null(zip))
      return()
    annualDf <- mapsnowdf[which(mapsnowdf$Zip==zip), 5:16 ]
    print("inside plot")
    
    title <- paste("Annual Snow Accumulations for " , mapsnowdf[ which(mapsnowdf$Zip==zip),2],":",mapsnowdf[ which(mapsnowdf$Zip==zip),17],"inches",sep=" ")
print(title)
    t_annualDF <- transpose(annualDf)
    t_annualDF
    t_annualDF <- cbind(Month=colnames(annualDf),Temp=t_annualDF)
    t_annualDF
    
    t_annualDF$Month<-factor(t_annualDF$Month,levels=c("January","February","March","April","May","June","July","August","September","October","November","December"),ordered=TRUE)
    t_annualDF$V1 <- as.double( t_annualDF$V1)
    
    print(t_annualDF)
    xlayout <- list(title = "Month")
    ylayout <- list(title = "Accumulations"  )
     plot_ly(data = t_annualDF, x =  ~Month, y = ~V1, type="bar")%>%
       layout(title=title,yaxis = list(title = 'Accumulations', range = c(0,max(t_annualDF$V1))))
    
    
  })
 
  
})
