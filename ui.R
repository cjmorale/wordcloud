library(shinythemes)

shinyUI(
  
  fluidPage(theme = shinytheme("flatly"),

  headerPanel(
    h1("Word Clouds ") 
    ),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(

    sidebarPanel(
      fileInput('file1', 'Choose file to upload',
                accept = c(
                  '.csv'
                )
      ),

      h4("Process Responses"),
      checkboxInput('stem', 'Stem words', FALSE),
      checkboxInput('rmpunc', 'Remove punctuation', FALSE),
      checkboxInput('rmstop', 'Remove stopwords', FALSE),
      sliderInput("minfreq", label = "Minimum Frequency:",
                  min = 1, max = 10, value = 1, step = 1)
    ),

  mainPanel(

    tabsetPanel(
 
      tabPanel("Word Cloud",
             plotOutput("plot")
                        ),
      tabPanel("Reports", fluidRow(h2()), h4("Download Word Cloud"), downloadButton('downloadReport'))
      
    )
  )
  )
))
