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

shinyUI(
        fluidPage(
                tags$h1 ("Crime analysis in Inner London"),
                                                    sidebarPanel(
                                                            helpText("Search for Crime in your Borough"),
                                                                            selectInput("boroughs", "Select a Borough", choices = boroughs, selected = "Camden"),
                                                                            checkboxInput("Anti-social_behaviour", "Anti-social behaviour", TRUE),
                                                                            checkboxInput("Bicycle_theft", "Bicycle theft", TRUE),
                                                                            checkboxInput("Burglary", "Burglary", FALSE),
                                                                            checkboxInput("Criminal_damage_and_arson", "Criminal damage and arson", FALSE),
                                                                            checkboxInput("Drugs", "Drugs", FALSE),
                                                                            checkboxInput("Other_crime", "Other crime", FALSE),
                                                                            checkboxInput("Other_theft", "Other theft", FALSE),
                                                                            checkboxInput("Possession_of_weapons", "Possession of weapons", FALSE),
                                                                            checkboxInput("Public_order", "Public order", FALSE),
                                                                            checkboxInput("Robbery", "Robbery", FALSE),
                                                                            checkboxInput("Shoplifting", "Shoplifting", FALSE),
                                                                            checkboxInput("Theft_from_the_person", "Theft from the person", FALSE),
                                                                            checkboxInput("Vehicle_crime", "Vehicle crime", FALSE),
                                                                            checkboxInput("Violence_and_sexual_offences", "Violence and sexual offences", FALSE)
                                                                    ),
                                                                    mainPanel(plotOutput("myplot"))
                                                                                
                                                        
                                                                   ))
