library(shiny)
library(gapminder)
library(ggplot2)
library(colourpicker) 
library(plotly)
library(dplyr)
library(shinyWidgets)
library(DT)

my_css <- " 
#download_data {
/* Change the background color of the download button to orange. */
background: orange;
}
"

# Define UI for the application
ui <- fluidPage(
    titlePanel(h2('Make the perfect plot using Shiny')), 
    tags$style(my_css),
    sidebarLayout(
        sidebarPanel(
            textInput("title", em("Choose a title"), "GDP vs Life Expectancy"),
            textInput("x_label", em("Choose the x label "), "GDP"),
            textInput("y_label", em("Choose the y label"), "Life Expectancy"),
            numericInput("size", em("Chosse the point size"), 1, 1),
            # Add a checkbox for line of best fit
            materialSwitch("fit",  strong(em("Add line of best fit")), value = FALSE,  status = "danger"),
            colourInput("color", em("Choose the point color"), value ="blue"),
            # Add a continent dropdown selector
            pickerInput("continents", em("Chose the continents"),
                        choices =  levels(gapminder$continent),
                        multiple = TRUE,
                        selected = "Europe",
                        options = list(style = "btn-danger")), 
            # Add a slider selector for years to filter
            sliderInput("years", em("How many years?"), min = min(gapminder$year)
                        , max = max(gapminder$year), value = c(1977,2002), sep='', step=1)
        ),
        mainPanel(
          tabsetPanel(
            tabPanel("Customize plot",
             plotlyOutput("plot", width = 600, height = 600)
            ), 
            tabPanel("Explore data",
            sliderInput(inputId = "life", label = "Life expectancy",min = 0, max = 120, value = c(30, 50)),
            # download button
            downloadButton(outputId = "download_data", label = "Download"),
            #tableOutput("table")
            DT::DTOutput("table")
            )
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
  data_plot() %>% filter(between(lifeExp, input$life[1], input$life[2]))
})
  
output$plot <- renderPlotly({
        ggplotly({
  
        p <- ggplot(data_plot(), aes(gdpPercap, lifeExp)) +
             geom_point(size = input$size, col = input$color) +
             scale_x_log10() +
             ggtitle(input$title) +
             xlab(input$x_label) +
             ylab(input$y_label)
        
        # When the "fit" checkbox is checked, add a line of best fit
        if (input$fit) {
            p <- p + geom_smooth(method = "lm")
        }
        p
    })
  })  
    
output$table <-  DT::renderDT({
  data_table()
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