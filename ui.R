library(shiny)
library(shinythemes)

shinyUI(
  fluidPage(
    theme = shinytheme("united"),
    titlePanel("Wsparcie dla cateringu dietetycznego"),
    sidebarLayout(
      sidebarPanel(
        # helpText("Shiny app based on an example given in the rhandsontable package.", 
        numericInput("calories", "kalorie:", min = 0, max = NA, value = 1200, step = 100),
        numericInput("n.diets", "liczba diet:", min = 0, max = NA, value = 1, step = 1),
        fileInput("shopping.data", "Dodaj liste zakupow"),
        # textInput("zakupy", "lista zakupow"),
        actionButton("add.diet", "Dodaj diete"),
        helpText(""),
        downloadButton("download.button", "Pobierz liste zakupow")
      ),
      mainPanel(
        dataTableOutput("df.portions"),
        dataTableOutput("df.shopping.list")
      )
    )
  )
)