library(shiny)
shinyUI(
  
fluidPage(
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
      "Darren Green (2019)",
      img(src='parasite_2.png',style="width: 64px; align: right; margin-left: 2em")
    )
  )
)

)
