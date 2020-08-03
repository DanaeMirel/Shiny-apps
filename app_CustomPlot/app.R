
#------------------------------#
#---# customize your plots #---#
#------------------------------#

library("shiny")
library("gapminder")
library("ggplot2")
library("colourpicker") 
library("plotly")
library("dplyr")
library("shinyWidgets")
library("DT")

# Define UI for the application
ui <- fluidPage(
    titlePanel(h2('Make the perfect plot using Shiny')) 
    , sidebarLayout(
        #---# SIDEBARPANEL #---#
        sidebarPanel(
              textInput(inputId = "title"
                        , label = em("Choose a title")
                        , value = "GDP vs Life Expectancy")
            , textInput(inputId = "x_label"
                        , label = em("Choose the x label ")
                        , value = "GDP")
            , textInput(inputId = "y_label"
                        , label = em("Choose the y label")
                        , value = "Life Expectancy")
            , numericInput(inputId = "size"
                           , label = em("Chosse the point size")
                           , value = 1
                           , step = 1)
            #---# Add a checkbook for adding a line representing the best fit #---#
            , materialSwitch(inputId = "fit"
                             ,  label = strong(em("Add line of best fit"))
                             , value = FALSE
                             ,  status = "danger")
            , colourInput(inputId = "color"
                          , label = em("Choose the point color")
                          , value ="blue")
            , pickerInput(inputId = "continents"
                          , label = em("Chose the continents")
                          , choices =  levels(gapminder$continent)
                          , multiple = TRUE
                          , selected = "Europe"
                          , options = list(style = "btn-danger")) 
            #---# Add a slider selector for years to filter #---#
            , sliderInput(inputId = "years"
                          , label = em("How many years?")
                          , min = min(gapminder$year)
                          , max = max(gapminder$year)
                          , value = c(1977, 2002)
                          , sep=''
                          , step=1)
        )
        #---# MAINPANEL #---#        
        , mainPanel(
            tabsetPanel(
              tabPanel("Customize plot"
                       , plotlyOutput("plot", width = 600, height = 600)) 
            , tabPanel("Explore data"
                       , sliderInput(inputId = "life"
                                     , label = "Life expectancy"
                                     , min = 0
                                     , max = 120
                                     , value = c(50, 70))
            #---# download button #---#
            , downloadButton(outputId = "download_data"
                             , label = "Download")
            , DT::DTOutput("table"))
            )
        )
    )
)

# Define the server logic
server <- function(input, output){

data_plot <- reactive({      
    data <- gapminder %>%
      filter(continent %in% input$continents & between(year, input$years[1], input$years[2]))  
  })

data_table <- reactive({
  data_plot() %>% 
    filter(between(lifeExp, input$life[1], input$life[2]))
})
  
output$plot <- renderPlotly({
  
        ggplotly({
        p <- ggplot(data_plot(), aes(gdpPercap, lifeExp)) +
             geom_point(size = input$size, col = input$color) +
             scale_x_log10() +
             ggtitle(input$title) +
             xlab(input$x_label) +
             ylab(input$y_label) 
        
        # When the "fit" checkbook is checked, add a line of best fit
        if (input$fit) {
            p <- p + geom_smooth(method = "lm")
        }
        p
      })
  })  
    
output$table <- DT::renderDT({
  
  datatable(data_table()
           , class = 'cell-border stripe'
           , rownames = FALSE
           , colnames = c('Country', 'Continent', 'Year', 'Life expectancy', 'Population', 'GDP per capita')
           , caption = htmltools::tags$caption(style = 'caption-side: bottom; text-align: center;'
           , 'Table 1: ', htmltools::em('Information filtered by continent, year and life expectancy in years.'))
           )
})

output$download_data <- downloadHandler(
  filename <- "gapminder_filtered_data.csv",
  content <- function(file){
    data_table()
  }
)
    
}

# Run the application
shinyApp(ui = ui, server = server)
