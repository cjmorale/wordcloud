library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

shinyServer(function(input, output, session) {
  
  Data <- reactive({
    inFile <- input$file1
    print(is.null(inFile))
    if(is.null(inFile))
      return(NULL)
    read.csv(inFile$datapath, header = TRUE, sep =",")
  })
  
  observe({

  observeEvent(input$file1, {
    output$plot <- renderPlot({ 
      docs <- Corpus(VectorSource(as.character(Data()$Words)))
      # Convert the text to lower case
      docs <- tm_map(docs, content_transformer(tolower))
      # Remove numbers
      docs <- tm_map(docs, removeNumbers)
      # Remove english common stopwords
      if(input$rmstop){
        docs <- tm_map(docs, removeWords, stopwords("english"))
      }
      # Remove punctuations
      if(input$rmpunc){
        docs <- tm_map(docs, removePunctuation)
      }
      # Eliminate extra white spaces
      docs <- tm_map(docs, stripWhitespace)
      # Text stemming
      if(input$stem){
        docs <- tm_map(docs, stemDocument)
      }
      
      dtm<- TermDocumentMatrix(docs)
      m <- as.matrix(dtm)
      v <- sort(rowSums(m),decreasing=TRUE)
      d <- data.frame(word = names(v),freq=v)
  
      wordcloud(words = d$word, freq = d$freq, min.freq = input$minfreq,
                max.words=200, random.order=FALSE, rot.per=0.35, 
                colors=brewer.pal(8, "Dark2"))
      })
    
    output$downloadReport <- downloadHandler(
      
      filename = function(){
        paste('word_cloud-', Sys.Date(), '.docx')
      },
      content = function(file) {
        library(rmarkdown)
        out<-render("wordcloud.Rmd","word_document",quiet = TRUE)
        file.rename(out, file)
      }
      
    )
   })
  })
})

  
  



