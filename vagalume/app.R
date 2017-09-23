library(vagalumeR)
library(shiny)
library(tm)
library(lattice)
library(tidyverse)

shinyApp(
  
  ui = fixedPage(fixed = TRUE,
                 sidebarLayout(fluid = FALSE, 
                               sidebarPanel(width = 4,
                                            tags$head(
                                              tags$style(type="text/css", "select { max-width: 140px; }"),
                                              tags$style(type="text/css", ".span4 { max-width: 190px; }"),
                                              tags$style(type="text/css", ".well { max-width: 180px; }")
                                            ),
                                            p("Digite o nome de um artista /banda"),
                                            verbatimTextOutput("info"),
                                            
                                            textInput(inputId="artist",
                                                        label="Nome",
                                                        value="Chico Buarque"),
                                            sliderInput(inputId = "qt",
                                                        label = "Quantidade de 
                                                        Músicas",
                                                        value = 5,
                                                        min = 1,
                                                        max = 30)
                               ),
                               
                               mainPanel(width = 8,
                                         plotOutput("plot1",
                                                    height = "400px", width = "580px")
                               )
                 )
  ),
  
  ##======================================================================
  server = function(input, output) {
    key <- "3f4f4a35789cae8ce84b5579069db511"
    
    #-----------
    
    output$plot1 <- renderPlot({
      mm <- input$artist
      mm <- tolower(mm)
      mm <- gsub(" ", "-", mm)
      
      song <- songNames(mm)
      let <- ldply(map(song$song.id[1:input$qt], lyrics, type = "id", key = key),
                   data.frame)
      
      cps <- VCorpus(VectorSource(let$text),
                     readerControl = list(language = "pt"))
      cps <- tm_map(cps, FUN = content_transformer(tolower))
      cps <- tm_map(cps, FUN = removePunctuation)
      cps <- tm_map(cps, FUN = removeNumbers)
      cps <- tm_map(cps, FUN = stripWhitespace)
      cps <- tm_map(cps,
                    FUN = removeWords,
                    words = stopwords("portuguese"))
      cps <- tm_map(cps,
                    FUN = removeWords,
                    words = "\t")
      
      dtm <- DocumentTermMatrix(cps)
      
      
      frq <- slam::colapply_simple_triplet_matrix(dtm, FUN = sum)
      frq <- sort(frq, decreasing = TRUE)
      
      barchart(head(frq, n = 45), xlim = c(0, NA),
               col =  "lightsalmon", 
               xlab = "Frequência",
               ylab = "Palavras",
               strip = strip.custom(bg = "white"))
    })
    
  },
  options = list(height = 300)
)