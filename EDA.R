library(sunburstR)
sequences <- read.csv(
  system.file("examples/visit-sequences.csv",package="sunburstR")
  ,header = FALSE
  ,stringsAsFactors = FALSE
)[1:200,]


sequences
sund2b(sequences)

sund2b(
  sequences,
  colors = htmlwidgets::JS("d3.scaleOrdinal(d3.schemeCategory20b)")
)


sund2b(
  sequences,
  colors = list(range = RColorBrewer::brewer.pal(9, "Set3"))
)

#install.packages('treemap')

library(treemap)
library(d3r)
rhd <- random.hierarchical.data()
tm <- treemap(
  rhd,
  index = paste0("index", 1:3),
  vSize = "x",
  draw = FALSE
)$tm


sund2b(
  d3_nest(tm, value_cols = colnames(tm)[-(1:3)]),
  colors = htmlwidgets::JS(
    # yes this is a little different, so please pay attention
    #  "function(d) {return d.color}" will not work
    "function(name, d){return d.color || '#ccc';}"
  ),
  valueField = "vSize"
)




library(shiny)
ui <- sund2bOutput("sun")
server <- function(input, output, session) {
  output$sun <- renderSund2b({
    sund2b(sequences)
  })
}
shinyApp(ui, server)
