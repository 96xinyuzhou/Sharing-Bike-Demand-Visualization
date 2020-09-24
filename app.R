library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
library(dplyr)
library(leaflet)
library(shinyjs)
library(shinythemes)
library(shinyWidgets)
library(sunburstR)
cv_cases<-read.csv('dataset.csv')

meatdf = read.csv('dataset.csv') %>%
  mutate_if(is.factor, as.character) 


ui<-navbarPage(theme = shinytheme("flatly"), collapsible = TRUE,
  title = img(src="ofobike.png", height = "40px"),
               tabPanel("BIKE SHARING DEMAND", 
                        img(src = 'Washingont-Keyart.jpg',height="800px")),
  
  
               tabPanel("INTRODUCTION",value="introduction",
                        img(src="512x512bb.jpg", height = "200px"),
                        
                        shinyjs::useShinyjs(),
                        
                        tags$head(tags$script(HTML('
                                                       var fakeClick = function(tabName) {
                                                       var dropdownList = document.getElementsByTagName("a");
                                                       for (var i = 0; i < dropdownList.length; i++) {
                                                       var link = dropdownList[i];
                                                       if(link.getAttribute("data-value") == tabName) {
                                                       link.click();
                                                       };
                                                       }
                                                       };
                                                       '))),
                        
                        fluidRow(
                          HTML("
                                     
                                     <section class='banner'>
                                     <h2 class='parallax'>Bike sharing demand</h2>
                                     <p class='parallax_description'>2011-2012 Washionton D.C.</p>
                                     </section>
                                     ")
                        ),
                        
                        fluidRow(
                          column(3),
                          column(6,
                                 shiny::HTML("<br><br><center> <h1>What you'll find here</h1> </center><br>"),
                                 shiny::HTML("<h5>An interactive tool to help you explore the tender of bike sharing demand. With information about the 
                                                   relationship between demand and other variables, and more, you can 
                                                   build your own path based on what is meaningful to you.</h5>"),
                                 img(src="DC-bicycle.jpg", height = "350px")
                          ),
                          column(3)
                        ),
                        
                        
                        fluidRow(
                          
                          style = "height:50px;"),
                        
                        # PAGE BREAK
                        tags$hr(),
                        
                        fluidRow(
                          column(3),
                          column(6,
                                 shiny::HTML("<br><br><center> <h1>How it can help you</h1> </center><br>"),
                                 shiny::HTML("<h5>With most things, the more you know, the better your decisions 
                                                   will be. This project helps you know when and where are best
                                             for gettong out by shared bike.</h5>"),
                                 img(src="0_L6IdYhKrHhuqTlCn.png", height = "500px")
                          ),
                          column(3)
                        ),
                        
                        fluidRow(
                          
                          style = "height:50px;"),
                        
                        # PAGE BREAK
                        tags$hr(),
                        
                        # WHERE
                        fluidRow(
                          column(3),
                          column(6,
                                 shiny::HTML("<br><br><center> <h1>Where it came from</h1> </center><br>"),
                                 shiny::HTML("<h5>The dataset is from kaggle bike sharing demand compeition.</h5>"),
                                 img(src="444.jpg", height = "200px")
                          ),
                          column(3)
                        ),
                        
                        fluidRow(
                          
                          style = "height:50px;"),
                        
                        # PAGE BREAK
                        tags$hr(),
                        
                        
                        # HOW TO START
                        fluidRow(
                          column(3),
                          column(6,
                                 shiny::HTML("<br><br><center> <h1>How to get started</h1> </center><br>"),
                                 
                          ),
                          column(3)
                        ),
                        
                        
                        # BUTTONS TO START
                        fluidRow(
                          column(3),
                          column(6,
                                 
                                 tags$div(class = "wrap",
                                          div(class = "center", 
                                              style="display: inline-block;vertical-align:top; width: 225px;",
                                              tags$a("Bike sharring:Declare Your Independence",
                                                     onclick = "window.open('https://www.capitalbikeshare.com/', '_blank')",
                                                     class="btn btn-primary btn-lg"),
                                              tags$hr(),
                                              
                                              div(class = "center",
                                                  style="display: inline-block;vertical-align:top; width: 225px;",
                                                  tags$a("FIT5147 Narrative Visualisation Project", 
                                                         onclick="fakeClick('ABOUT')", 
                                                         class="btn btn-primary btn-lg")
                                              )
                                          )
                                 )
                          ),
                          column(3)
                        ),
                        
                        
                        fluidRow(
                          
                          style = "height:50px;"),
                        
                        # PAGE BREAK
                        tags$hr(),
                        
                        fluidRow(shiny::HTML("<br><br><center> <h1>Ready to Get Started?</h1> </center>
                                                 <br>")
                        ),
                        fluidRow(
                          column(3),
                          column(6,
                                 tags$div(align = "center",   
                                          tags$a("Start", 
                                                 onclick="fakeClick('WEATHER')",
                                                 class="btn btn-primary btn-lg")
                                 )
                          ),
                          column(3)
                        ),
                        fluidRow(style = "height:25px;"
                        ),
                        HTML('<img src="bikes.png",weight="600px"'),
                        tags$hr()
                      
                   
               ),
                        
                        
  
  
               tabPanel(title="WEATHER",h3("How weather affectd demand:", style="color:green"),value="WEATHER",
                        fluidRow(column(12,
                                                  verticalLayout(
                                                    pickerInput(
                                                      inputId = "year",
                                                      label = "year",
                                                      selected = 2011,
                                                      choices = unique(meatdf$year),
                                                      options = list(style = "btn-primary")
                                                    ),
                                                    pickerInput(
                                                      inputId = "month",
                                                      label = "month",
                                                      selected = 1,
                                                      choices = unique(meatdf$month),
                                                      options = list(style = "btn-primary")
                                                    ),
                                                    sund2bOutput('sunb')
                                                  )
               ))),
  
  
  tabPanel("MAP", value='Map',leafletOutput("bbmap", height=1000)),
  tabPanel("DATA",img(src = "0_ftOal7fKVCNtJr4N.png", height="300px"),
           numericInput("maxrows", "Rows to show", 10),
           verbatimTextOutput("rawtable"),
           downloadButton("downloadCsv", "Download as CSV"),tags$br(),tags$br(),
           "Adapted from data published by ", tags$a(href="https://www.kaggle.com/c/bike-sharing-demand/data", 
                                                     "Bike Sharing Demand: Forecast use of a city bikeshare system.")
  ),
  tabPanel("ABOUT",value='ABOUT', fluid = TRUE,
           fluidRow(
             column(6,
                    #br(),
                    h3(p("About the Project", style="color:green")),
                    h4(p("FIT5147 Narrative Visualisation Project")),
                    br(),
                    h5(p("This project is intended to find the factor of bike sharing demand in Washington D.C.")),
                    br(),
                    h5(p("In this project, we are asked to create an interactive narrative visualisation that communicates some of your findings from the Data Exploration Project.")),
                    br(),
                    h5(p("I hope you find it interesting and/or useful.  Any comments or questions are welcome at xzho0060@student.monash.edu"))
                    
                    #hr(),
                    
             ),
             column(6,
                    #br(),
                    #             HTML('<img src="GregPicCrop.png", height="110px"    
                    # style="float:right"/>','<p style="color:black"></p>'),
                    h3(p("About the Author", style="color:green")),
                    h5(p("I'm Xinyu Zhou. My major is data science and this is my third semester of Master.My student id is 30199719 :)")
                    ),
                    HTML('<img src="59DdgdEu_400x400.jpg", height="200px"'),
                    br()
             )
           ),
           br(),
           hr(),
           h3("Reference",style="color:green"),
           h6('Washington DC Minecraft Lesson Guide - Lifeboat Network (2020) Retrieved from https://lbsg.net/washington-dc-minecraft-lesson-guide/'),
           h6("Monash InfoTech (@MonashInfotech) | Twitter (2011) Retrieved from https://twitter.com/monashinfotech"),
           h6("ODSC - Open Data Science (2019) 10 Tips to Get Started with Kaggle Retrieved from https://medium.com/@ODSC/10-tips-to-get-started-with-kaggle-fc7cb9316d27"),
           h6("Bike Stations Washington DC by H3 Apps, LLC (2018) https://appadvice.com/app/bike-stations-washington-dc/1400488560"),
           h6('Smart citied connect (2017) Washington DC Conducts Demonstration Program for Dockless Bike Sharing Retrieved from https://smartcitiesconnect.org/washington-dc-conducts-demonstration-program-for-dockless-bike-sharing/'),
           h6("Capital Bike Share Locations (2020) https://opendata.dc.gov/datasets/capital-bike-share-locations/data"),
           h6('Kaggle (2014). Bike sharing demand competition.Retrieved from https://www.kaggle.com/c/bike-sharing-demand'),
           HTML('<img src="bikes.png",weight="600px"')
           
  )
)







server<-shinyServer(function(input, output, sessio) {
  # Import Data and clean it
  
  bb_data <- read.csv("Capital_Bike_Share_Locations.csv" )
  bb_data <- data.frame(bb_data)
  bb_data$LATITUDE <-  as.numeric(bb_data$LATITUDE)
  bb_data$LONGITUDE <-  as.numeric(bb_data$LONGITUDE)
  
  # new column for the popup label
  
  bb_data <- mutate(bb_data, cntnt=paste0('<strong>Object id: </strong>',OBJECTID,
                                          '<br><strong>Id:</strong> ', ID,
                                          '<br><strong>Address:</strong> ', ADDRESS,
                                          '<br><strong>NUMBER:</strong> ',TERMINAL_NUMBER,
                                          '<br><strong>Latitude:</strong> ',LATITUDE,
                                          '<br><strong>Longitude:</strong> ',LONGITUDE,
                                          '<br><strong>Installed:</strong> ',INSTALLED,
                                          '<br><strong>Bike numbers:</strong> ',NUMBER_OF_BIKES))
  
  # create a color paletter for category type in the data file
  low<-c(-1,10)
  middle<-c(11,24)
  high<-c(25,40)
  pal <- colorFactor(pal = c("blue",'red'), domain = c(bb_data$NUMBER_OF_BIKES))
  
  # create the leaflet map  
  output$bbmap <- renderLeaflet({
    leaflet(bb_data) %>% 
      addCircles(lng = ~LONGITUDE, lat = ~LATITUDE) %>% 
      addTiles() %>%
      addCircleMarkers(data = bb_data, lat =  ~LATITUDE, lng =~LONGITUDE, 
                       radius = 3, popup = ~as.character(cntnt), 
                       color = ~pal(NUMBER_OF_BIKES),
                       stroke = FALSE, fillOpacity = 0.8)%>%
      addLegend(pal=pal, values=bb_data$NUMBER_OF_BIKES,opacity=0.5, na.label = "Not Available")%>%
      addEasyButton(easyButton(
        icon="fa-crosshairs", title="ME",
        onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
  })
  
  
  
  output$downloadCsv <- downloadHandler(
    filename = function() {
      paste("Bike_Sharing_demand_data.csv", sep="")
    },
    content = function(file) {
      write.csv(cv_cases %>% select(c(season,holiday,workingday,weather,temp,atemp,humidity,windspeed,casual,registered,count,year,month,day,hour)), file)
    }
  )
  
  
  output$rawtable <- renderPrint({
    orig <- options(width = 1000)
    print(tail(cv_cases %>% select(c(season,holiday,workingday,weather,temp,atemp,humidity,windspeed,casual,registered,count,year,month,day,hour)), input$maxrows), row.names = FALSE)
    options(orig)
  })
  
  
  observe({
    df = filter(meatdf,  year== input$year, month == input$month) %>%
      mutate(VAR = paste(season,weather,temp,humidity,windspeed, sep = '-')) %>%
      select(VAR, count)
    output$sunb <- renderSund2b({
      sund2b(df, colors = htmlwidgets::JS("d3.scaleOrdinal(d3.schemeCategory20b)"))

    })
    
  
  })
  
})






shinyApp(ui, server)


