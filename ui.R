library(shiny)

shinyUI(pageWithSidebar(
  headerPanel(
    h1("Graph and Predict California City Growth"),
    h2("Data Sicence Project")
    ),
  
  
  sidebarPanel(
    h3('Choose the County and city of Interest'),
    p('The predict population in year is '),
    selectInput("number", label = h3("Select"), 
        choices = list("First" = 1, "Second" = 2, "Third" = 3), selected = 1)
    
    
    submitButton('Submit')
    ),
  
  
  mainPanel(
    h3('The Plot'),
    textOutput("text1"),
    
    verbatimTextOutput("prediction")
  )
))

