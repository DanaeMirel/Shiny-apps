
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(wesanderson)
library(RColorBrewer)
library(knitr)
library(kableExtra)
library(gridExtra)

usa_ufo_sightings <- read.csv('C:/Git/shiny-apps/usa_ufo_sightings.csv')

ufo_sightings <- usa_ufo_sightings %>% mutate(date_sighted = as.Date(date_sighted, format = "%Y-%m-%d"))


ui <- fluidPage(
    # CODE BELOW: Add a title
    titlePanel('UFO Sightings'),    
    sidebarLayout(
        sidebarPanel(
            p('The National UFO Reporting Center (NUFORC) has collected sightings data throughout the last century.
            This app allows users to select a U.S. state and a time period in which the sightings occurred.'),
            
            # CODE BELOW: One input to select a U.S. state
            # And one input to select a range of dates
            selectInput('state', 'Choose a U.S. state:', choices = levels(ufo_sightings$state)),
            dateRangeInput("dates",'Choose a date range:'
                           , start = min(ufo_sightings$date_sighted)
                           , end = max(ufo_sightings$date_sighted))
        ),
        mainPanel(
            tabsetPanel(
                tabPanel('Plot',
                    plotOutput('shapes')),
                tabPanel('Table',
                    tableOutput('duration_table'))
            )
        )
    )
)


server <- function(input, output) {
    
    shapes_summ <- function(){
        
        ufo_sightings_summ <- ufo_sightings %>%
            filter(state==input$state & between(date_sighted
                                                , as.Date(input$dates[1], format = "%Y-%m-%d")
                                                , as.Date(input$dates[2], format = "%Y-%m-%d"))) %>% 
            group_by(shape) %>%
            mutate(avg = mean(duration_sec)
                   ,med=median(duration_sec)
                   ,min=min(duration_sec)
                   ,max=max(duration_sec)
                   ,n =n()) %>%  
            select(shape, avg,med,min, max,n) %>% 
            distinct() %>% 
            arrange(desc(n))
        
        ufo_sightings_summ$shape = factor(ufo_sightings_summ$shape, levels=ufo_sightings_summ$shape)
        
        return(ufo_sightings_summ)
    }
    
    output$shapes <- renderPlot({ 
        
        shapes_summ() %>% 
            ggplot(aes(x = shape, y = n, fill = shape)) +
            geom_col(alpha=0.5) + 
            guides(fill = FALSE) +
            scale_color_viridis(option = "A", discrete = TRUE) +
            theme(axis.text.x = element_text(angle=90), axis.title.y = element_text(angle=0)) 

        
        })
    
    output$duration_table <- function(){
        
        head(shapes_summ()) %>% 
        set_colnames(c("Shape", "Avg.", "Med.", "Min.", "Max.", "N")) %>%  
        kable(caption = "Average, median, minimum, and maximum duration of the sightings and number of sightings by shape"
             ,digits = 2
             ) %>% 
        kable_styling(full_width = F
                     ,bootstrap_options = "striped"
                     ,position = "left") 
        
        }
    
    
}

shinyApp(ui, server)

