
library(shiny)

bmi_help_text <- "Body Mass Index is a simple calculation using a person's height and weight.
The formula is BMI = kg/m2 where kg is a person's weight in kilograms and m2 is their height in metres squared. 
A BMI of 25.0 or more is overweight, while the healthy range is 18.5 to 24.9."

ui <- fluidPage(
    titlePanel(strong('BMI Calculator')),
    sidebarLayout(
        sidebarPanel(
            textInput('name', em('Enter your name')),
            # Enter heigth
            numericInput('height', em('Enter your height in meters'), 1.5, 1, 2),
            # Enter weight
            numericInput('weight', em('Enter your weight in Kilograms'), 60, 45, 120),
            # Show BMI
            actionButton("show_bmi", "Show BMI"),
            # An action button named "show_help"
            actionButton("show_help", "Help")
        ),
        mainPanel(
            textOutput("bmi")
        )
    )
)

server <- function(input, output, session) {

    # Display a modal dialog with bmi_help_text
    observeEvent(input$show_help, { showModal(modalDialog(bmi_help_text))})
    
    rv_bmi <- eventReactive(input$show_bmi, {
        input$weight/(input$height^2)
    })
    
    output$bmi <- renderText({
        bmi <- rv_bmi()
        paste("Hi", input$name, ". Your BMI is", round(bmi, 1))
    })
}

shinyApp(ui = ui, server = server)