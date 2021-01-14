#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    theme="styles.css",
    titlePanel("Reed–Frost model simulation"),
    sidebarLayout(
        sidebarPanel(
            helpText("Select values for the model run and then click 'GO!'."),
            h4("Disease parameters"),
            sliderInput("beta","transmission rate",min=0,max=10,step=0.1,value=2),
            sliderInput("vacc","prop. population vaccinated",min=0,max=1,step=0.01,value=0),
            sliderInput("N","total population size",min=1,max=2000,step=10,value=100),
            sliderInput("I0","initial infected population",min=1,max=100,step=1,value=1),
            h4("Simulation parameters"),
            sliderInput("time_points","duration of model",min=1,max=100,value=20),
            sliderInput("run_n","number of runs",min=1,max=100,value=1),
            actionButton("submit","GO!"),
            checkboxInput("show_s","Show S",T),
            checkboxInput("show_i","Show I",T),
            checkboxInput("show_r","Show R",F),
            checkboxInput("show_u","Show means",F)
        ),
        mainPanel(
            h4("Reed–Frost model graph"),
            plotOutput("plot",height="500px"),
            div("―Susceptible population",style="color:blue"),
            div("―Infected population",style="color:red"),
            div("―Removed population",style="color:black"),
            textOutput("oo1"),
            textOutput("oo2"),
            textOutput("oo3"),
            img(src='ioa_logo.png',style="width: 256px; align: left; margin-right: 2em"),
            "Darren Green (2021)",
            img(src='parasite_2.png',style="width: 64px; align: right; margin-left: 2em")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    D<-reactiveValues()
    D$active<-F
    D$err<-F
    source("model.r",local=T)
    
    observeEvent(input$submit, {
        D$err<-F
        ReadParams(input)
        if (!D$err) withProgress(
            message="Running simulations...",
            detail="Getting there...",
            value=0, min=0, max=input$N,
            {RunModel()}
        )
        D$active<-T
    })
    
    output$plot <- renderPlot({
        if (D$active) DrawGraph()
    })
    
    output$oo1 <- renderText({
        if (!D$active) return()
        paste("Mean final susceptible population:",FinalX(1))
    })
    
    output$oo2 <- renderText({
        if (!D$active) return()
        paste("Mean final infected population:",FinalX(2))
    })
    
    output$oo3 <- renderText({
        if (!D$active) return()
        paste("Mean final removed population:",FinalX(3))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
