library(shiny)
library(leaflet)
library(dplyr)

# TODO: fix the format date and reactivate the filter by date
# upfate to the latest date in february 2020

shootings <- read.csv('C:/Git/shiny-apps/app_shooting/mass-shootingsupdate.csv')

mass_shootings <- shootings %>%  
    select('location', 'date', 'latitude', 'longitude', 'case', 'fatalities')

text_about <- "This data was compiled by Mother Jones, nonprofit founded in 1976. 
               Originally covering cases from 1982-2012, this database has since been 
               expanded numerous times to remain current."

server <- function(input, output, session) {
    
    observeEvent(input$show_about,{
        showModal(modalDialog(text_about, title = 'About')) })
    
    rval_mass_shootings <- reactive({
        # MODIFY CODE BELOW: Filter mass_shootings on nb_fatalities and 
        # selected date_range.
        mass_shootings %>%
            filter( #between(date, input$date_range[1], input$date_range[2]) & 
                        fatalities >= input$nb_fatalities)
    })
    output$map <- leaflet::renderLeaflet({
        rval_mass_shootings() %>%
            leaflet() %>% 
            addTiles() %>%
            setView( -98.58, 39.82, zoom = 5) %>% 
            addTiles() %>% 
            addCircleMarkers(
                # CODE BELOW: Add parameters popup and radius and map them
                # to the summary and fatalities columns
                popup = ~ summary,
                radius = ~ fatalities,
                fillColor = 'red', color = 'red', weight = 1
            )
    })
}

ui <- bootstrapPage(
    theme = shinythemes::shinytheme('simplex'),
    leaflet::leafletOutput('map', height = '100%', width = '100%'),
    absolutePanel(top = 10, right = 10, id = 'controls',
                  sliderInput('nb_fatalities', 'Minimum Fatalities', 1, 40, 10),
                  dateRangeInput('date_range', 'Select Date', "2010-01-01", "2019-12-01"),
                  actionButton('show_about', 'About')
    ),
    tags$style(type = "text/css", "
    html, body {width:100%;height:100%}     
    #controls{background-color:white;padding:20px;}
  ")
)

shinyApp(ui, server)