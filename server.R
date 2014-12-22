library(shiny)


shinyServer(function(input, output) {
  output$text1 <- renderText({
    test<-list("one","two","three")[[as.integer(input$number)]]
    paste("test:",test,input$number)
  })
})