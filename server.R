library(shiny)
library(tidyverse)
source("functions.R")

shinyServer(
  function(input, output){
    values <- reactiveValues()
    # tabele do wyswietlania -------------------------
    values$df.portions <- data.frame(calories = numeric(), n.diets = numeric(), porcja = numeric())
    values$df.shopping.list <- data.frame(produkt = character(), n.g = numeric(), n.jednostek = numeric(), jednostka = character())
    # wczytanie csv --------------------------
    upload.csv <- reactive({
      infile <- input$shopping.data
      if (is.null(infile)) {
        return(NULL)
      }
      read.csv2(infile$datapath, header = FALSE)
    })
    # reakcja na nacisniecie przycisku
    observe({
      if(input$add.diet > 0){
        # tabela z porcjami -----------------
        isolate(values$df.portions <- add_row(values$df.portions, calories = input$calories, n.diets = input$n.diets, porcja = NA))
        isolate(values$sum.of.calories <- sum(with(values$df.portions, calories * n.diets)))
        isolate(values$df.portions$porcja <- round(values$df.portions$calories / values$sum.of.calories, 4))
        isolate(values$sum.of.calories <- NULL)
        # tabela z lista zakupow ---------------
        isolate(values$df.csvinput <- upload.csv())
        isolate(for(i in 1:nrow(values$df.csvinput)){
                  produkt.info <- get.everything(values$df.csvinput[i, 1])
                  if(produkt.info$nazwa %in% values$df.shopping.list$produkt){
                    values$df.shopping.list[values$df.shopping.list$produkt == produkt.info$nazwa, "n.g"] <- values$df.shopping.list[values$df.shopping.list$produkt == produkt.info$nazwa, "n.g"] + (input$n.diets * produkt.info$n.g) 
                    values$df.shopping.list[values$df.shopping.list$produkt == produkt.info$nazwa, "n.jednostek"] <- values$df.shopping.list[values$df.shopping.list$produkt == produkt.info$nazwa, "n.jednostek"] + (input$n.diets * produkt.info$n.jednostek) 
                  } else {
                    values$df.shopping.list <- add_row(values$df.shopping.list, 
                                                       produkt = produkt.info$nazwa,
                                                       n.g = produkt.info$n.g * input$n.diets,
                                                       n.jednostek = produkt.info$n.jednostek * input$n.diets,
                                                       jednostka = produkt.info$jednostka
                                               )
                    }
                }
        )
      }
    })
    output$download.button <- downloadHandler(
      filename = function(){
                    paste("lista zakupow - ", Sys.Date(), ".csv", sep="")
      },
      content = function(file){
        write.csv2(values$df.shopping.list, file)
      },
      contentType = "text/csv"
    )
    output$df.portions <- renderDataTable(values$df.portions)
    output$df.shopping.list <- renderDataTable(values$df.shopping.list)
  }
)