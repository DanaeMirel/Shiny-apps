
library("shiny")
library("leaflet")
library("dplyr")
library("lubridate") # formatting dates
library("readr")

shootings <- read_csv("/home/danae/Documents/Git/shiny-apps/app_shooting/mass-shootingsupdate.csv")

mass_shootings <- shootings %>%  
  mutate(Date = mdy(date)) %>% 
  select('Date','location', 'latitude', 'longitude', 'case', 'fatalities')

text_about <- "This data was compiled by Mother Jones, nonprofit founded in 1976. 
               Originally covering cases from 1982-2012, this database has since been 
               expanded numerous times to remain current."

server <- function(input, output, session) {
  
  observeEvent(input$show_about,{
    showModal(modalDialog(text_about, title = 'About')) })
  
  rval_mass_shootings <- reactive({
    # Filter mass_shootings on nb_fatalities and  selected date_range.
    mass_shootings %>%
      filter( between(Date, input$date_range[1], input$date_range[2]) & 
        fatalities >= input$nb_fatalities)
  })
  
  output$map <- leaflet::renderLeaflet({
    rval_mass_shootings() %>%
      leaflet() %>% 
      addTiles() %>%
      setView( -98.58, 39.82, zoom = 5) %>% 
      addTiles() %>% 
      addCircleMarkers(
        # Add parameters popup and radius and map them to the summary and fatalities columns
        popup = ~ summary,
        radius = ~ fatalities,
        fillColor = 'red', color = 'red', weight = 1
      )
  })
  
}
