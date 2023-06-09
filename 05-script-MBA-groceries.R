
library(gsheet)
library(tidyverse)
library(arules)
library(arulesViz)
library(viridis)

# Importar el DF ----

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
                  topN = 15,
                  col = viridis(n = 15),
                  horiz = T)



# Reglas ----

rules <- apriori(data = DF.trans,
                 parameter = list(supp = 0.0005,
                                  conf = 0.15,
                                  minlen = 2,
                                  maxlen = 3))
  
# Resultados ----
inspect(rules)  
  
plot(rules,
     method = "graph",
     engine = "htmlwidget")



## Fijando la mano izquierda ----

rules.lhs <- apriori(data = DF.trans,
                     parameter = list(supp = 0.001,
                                      conf = 0.05,
                                      minlen = 2,
                                      maxlen = 3),
                     appearance = list(lhs = "whole milk",
                                       default = "rhs"))

inspect(rules.lhs)



## Fijando la mano derecha ----

rules.rhs <- apriori(data = DF.trans,
                     parameter = list(supp = 0.001,
                                      conf = 0.07,
                                      minlen = 2,
                                      maxlen = 2),
                     appearance = list(rhs = "sausage",
                                       default = "lhs"))

inspect(rules.rhs)
