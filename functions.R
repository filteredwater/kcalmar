setwd("C:/Users/przemek/Desktop/shiny/kcalmarproplatinum")

library(stringr)
library(tidyverse)

# obszar testowania -------------------------------
# shopping.list <- read.csv2("kcal1500.csv", header = FALSE)
# napis <- shopping.list$V1[2]
# napis
# get.everything(napis)
# get.last.space.pos ------------
get.last.space.pos <- function(napis){
  str_locate_all(napis, " ") %>% unlist() %>% last()
}
# get.jednostka -------------------------------
# zwraca jednostke ze stringa, np. lyzka, sztuka
get.jednostka <- function(napis){
  x.pos <- str_locate(napis, " x ") %>% first()
  jednostka <- str_sub(napis, x.pos + 3)
  return(jednostka)
}
# get.n.jednostek -------------------------------
get.n.jednostek <- function(napis){
  last.space.pos <- get.last.space.pos(napis)
  n.jednostek <- str_sub(napis, last.space.pos + 1)
  return(as.numeric(n.jednostek))
}
# get.n.g -------------------------------
get.n.g <- function(napis){
  last.space.pos <- get.last.space.pos(napis)
  n.g <- str_sub(napis, last.space.pos + 1)
  return(as.numeric(n.g))
}
# get.everything --------------------------
# wyciaga wszystkie dane ze stringa
get.everything <- function(napis){
  jednostka <- get.jednostka(napis)
  napis <- str_remove(napis, str_c(" x ", jednostka))
  n.jednostek <- get.n.jednostek(napis)
  last.space.pos <- get.last.space.pos(napis)
  napis <- str_sub(napis, 1, last.space.pos -3)
  last.space.pos <- NULL
  n.g <- get.n.g(napis)
  last.space.pos <- get.last.space.pos(napis)
  napis <- str_sub(napis, 1, last.space.pos - 1)
  list.everything <- list(
    n.jednostek = n.jednostek,
    jednostka = jednostka,
    n.g = n.g,
    nazwa = napis
  )
  return(list.everything)
}
# add.new.row ------------------
# add.new.row <- function(df, list.everything, multip.by){
#   df <- add_row(df, 
#                 produkt = list.everything$nazwa,
#                 n.g = list.everything$n.g * multip.by,
#                 n.jednostek = list.everything$n.jednostek * multip.by,
#                 jednostka = list.everything$jednostka
#         )
# }
# # mod.shopping.list ----------------
# mod.shopping.list <- function(df, list.everything, multip.by){
#   
# }
# # add.to.shopping.list ---------------
# add.to.shopping.list <- function(zrodlo, cel, multip.by){
#   for(i in 1:nrow(zrodlo)){
#     produkt.info <- get.everything(zrodlo[i, 1])
#     if(produkt.info$nazwa %in% cel$produkt){
# 
#     } else {
#       cel <- add.new.row(cel, produkt.info, multip.by)
#     }
#   }
#   
# }
# # test add.to.shopping.list ------------
# i <- 2
# zrodlo <- read.csv2("kcal1500.csv", header = FALSE)
# cel <- data.frame(produkt = character(), n.g = numeric(), n.jednostek = numeric(), jednostka = character())
# produkt.info
# 
# multip.by <- 3
# cel <- add.new.row(cel, produkt.info, multip.by)
# zastepstwo
