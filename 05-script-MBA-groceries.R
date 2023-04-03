
library(gsheet)
library(tidyverse)
library(arules)
library(arulesViz)
library(viridis)

# Impotar el DF ----

DF <- read.csv(text = gsheet2text(url = "https://docs.google.com/spreadsheets/d/1NTjA8nrmcWltvZn4oq5KJK7-R4Mb-_is_5vVsoBDCv0/edit?usp=sharing",
                                  format = "csv"),
               stringsAsFactors = F)


# Crear las canastas ----

## Asignar un ID de canasta

DF1 <- DF %>% 
  mutate(basket.id = paste(Member_number, Date, sep = "_")) %>% 
  select(basket.id, itemDescription)



## Crear una lista

DF.list <- split(x = DF1$itemDescription,
                 f = DF1$basket.id)


## Formato transacción

DF.trans <- as(object = DF.list,
               Class = "transactions")

class(DF.trans)



# Análisis descriptivo ----

itemFrequencyPlot(x = DF.trans,
                  type = "relative",
                  topN = 10,
                  col = viridis(n = 10),
                  horiz = T)



