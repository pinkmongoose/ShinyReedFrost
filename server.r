library(shiny)
shinyServer(

  function(input,output) {
    
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
  

)
