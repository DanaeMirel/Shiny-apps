library(shiny)
library(leaflet)
library(dplyr)
library(lubridate) # formating dates

shootings <- read.csv('C:/Git/shiny-apps/app_shooting/mass-shootingsupdate.csv')

mass_shootings <- shootings %>%  
  mutate(Date = mdy(date)) %>% 
  select('Date','location', 'latitude', 'longitude', 'case', 'fatalities')

text_about <- "This data was compiled by Mother Jones, nonprofit founded in 1976. 
               Originally covering cases from 1982-2012, this database has since been 
               expanded numerous times to remain current."


ui <- bootstrapPage(
  
    theme <- shinythemes::shinytheme('simplex'),
    
    leaflet::leafletOutput('map', height = '100%', width = '100%'),
    
    absolutePanel(top = 10, right = 10, id = 'controls',
                  sliderInput('nb_fatalities', 'Minimum Fatalities', 1, 40, 10),
                  dateRangeInput('date_range', 'Select Date', min(mass_shootings$Date), max(mass_shootings$Date)),
                  actionButton('show_about', 'About')
    ),
    
    tags$style(type = "text/css", "
    html, body {width:100%;height:100%}     
    #controls{background-color:white;padding:20px;}")
)
