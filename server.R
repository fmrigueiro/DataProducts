library(shiny)
library(ggplot2)
library(dplyr)

files = list.files(pattern="*.csv")

myfiles = do.call(rbind, lapply(files, function(x) read.csv(x, header = T, stringsAsFactors = FALSE)))

Df <- subset(myfiles, !is.na(myfiles$Longitude) == TRUE)

Df$LSOA.name <- gsub('.{5}$', '', Df$LSOA.name)
boroughs <- c("Camden", "Greenwich", "Hackney", "Hammersmith and Fulham", "Islington", "Kensington and Chelsea", "Lambeth", "Lewisham", "Southwark", "Tower Hamlets", "Wandsworth", "Westminster")

Df$Crime.type <- as.factor(Df$Crime.type)

Crimes <- levels(Df$Crime.type)

shinyServer(function(input, output, session) {
        

        
        output$myplot <- renderPlot({
                
                crimeTypesActual <- levels(Df$Crime.type)
                crimeTypesActive <- c(input$`Anti-social_behaviour`, input$Bicycle_theft, input$Burglary,
                                      input$Criminal_damage_and_arson, input$Drugs, input$Other_crime, input$Other_theft,
                                      input$Possession_of_weapons, input$Public_order, input$Robbery, input$Shoplifting,
                                      input$Theft_from_the_person, input$Vehicle_crime, input$Violence_and_sexual_offences)
                
                crimeTypes <- crimeTypesActual[crimeTypesActive]
                plotData <- Df[which(Df$Crime.type %in% crimeTypes), ]
                
                
                lineData <- plotData
                lineData <- subset(lineData, lineData$LSOA.name == input$boroughs)
                                   
                tbl <- c("Crime.type","Month")
                lineData <- lineData[, tbl]
                lineData$Month <- as.Date(strptime(paste(lineData$Month, "01", sep="-"), "%Y-%m-%d", tz = "UTC"), origin="1970-01-01")
                
                names(lineData)[2] <- "Date"
                names(lineData)[1] <- "CrimeType"
                
                gd <- lineData %>% group_by(CrimeType, Date) %>% summarise(Occurences = length(Date))
                
                ggplot(gd,aes(x= Date, y=Occurences, color = CrimeType)) + geom_point() + geom_line()
                
        
        })
})
        
       


        
        