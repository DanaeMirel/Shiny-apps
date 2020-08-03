
#----------------------------#
#---# Popular baby names #---#
#----------------------------#

library("shiny")
library("ggplot2")
library("RColorBrewer")
library("gridExtra")
library("viridis")
library("babynames")
library("dplyr")
library("DT")
library("magrittr")
library("plotly")
library("shinythemes")
library("knitr")
library("kableExtra")

babynames <- babynames %>%
    mutate(year = as.factor(year))
#glimpse(babynames)

ui <- fluidPage(
    #---# title #---#
    titlePanel(h1("Most popular baby names by year"))
    , sidebarLayout(
        #---# SIDEBARPANEL #---#
        sidebarPanel(
             selectInput(inputId = 'sex'
                          , label = em('Select Sex')
                          , choices = c("Female" = "F", "Male" = "M"))
            , sliderInput(inputId = 'year'
                          , label = em('Select Year')
                          , min = 1880
                          , max = 2017
                          , value = 1900
                          , sep=''))
        #---# MAINPANEL #---#        
        , mainPanel(
            tabsetPanel(
                tabPanel('Plot', plotlyOutput('plot_trendy_names'))
              , tabPanel('Table', tableOutput('table_trendy_names')))
            ) 
        )
    )

server <- function(input, output, session) {
    
    get_top_names <- function(){
        
        top_10_names <- babynames %>%
            filter(sex == input$sex) %>%
            filter(year == input$year) %>%
            top_n(10, prop) %>% 
            arrange(desc(prop))
        
        top_10_names$name <- factor(top_10_names$name, levels = top_10_names$name)
        return(top_10_names)
    }
    
    output$plot_trendy_names <- renderPlotly({
        
        get_top_names() %>% 
            ggplot(aes(x = name, y = prop, fill= name)) +
            geom_col(alpha = 0.75) +
            scale_fill_viridis(option = "D", discrete = TRUE) +
            theme(legend.position='none'
                  , axis.text.x = element_text(angle=90)
                  , axis.title.y = element_text(angle=0)) 
        
    })  
    
    output$table_trendy_names <- function()({
        
        get_top_names() %>% 
            select(name, n, prop) %>%  
            set_colnames(c('Name', 'N', 'Prop.')) %>% 
            kable(format = "html"
                  , caption = "The most popular names for the selected year and sex"
                  , digits = 2) %>%
            kable_styling(full_width = F
                          , bootstrap_options = "striped"
                          , position = "left") %>% 
            column_spec(2:3, bold = T)
    })
    
}

shinyApp(ui = ui, server = server)