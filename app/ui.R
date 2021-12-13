library(shiny)
library(plotly)
library(shinyBS)

fluidPage(

  title = "QuickViz",
  headerPanel('QuickViz'),

  sidebarPanel(
    bsCollapse(id = "collapseContainer", open = "Data", multiple = T,
               bsCollapsePanel("Data",
                               # Input: Select a file ----
                               fileInput("file1", "Choose CSV/RData File",
                                         multiple = TRUE,
                                         accept = c("text/csv",
                                                    "text/comma-separated-values,text/plain",
                                                    ".csv",
                                                    ".RData")),

                               selectInput('filterBy',
                                           'Filter By',
                                           choices = c("All"),
                                           selected = "All"),

                               selectInput('filterVal', 'Filter Value', choices = "All"),
                               style = "info"),
               bsCollapsePanel("Plot Variables",
                               selectInput('y', 'Y', c("None")),
                               selectInput('x', 'X', c("None")),

                               selectInput('color', 'Color',
                                           c(None='.')),
                               selectInput('size', 'Size',
                                           c(None='.')),
                               selectInput('frame', 'Animated Frame',
                                           c(None='.')),
                               selectInput('facet_row', 'Facet Row',
                                           c(None='.')),
                               selectInput('facet_col', 'Facet Column',
                                           c(None='.')),
                               selectInput('groupBy', 'Group By',
                                           c(None='.')),
                               style = "info"),
               bsCollapsePanel("Plot Type",
                               checkboxInput('scatter', 'Scatter', value = T),
                               checkboxInput('boxplot', 'Box'),
                               checkboxInput('jitter', 'Jitter'),
                               checkboxInput('smooth', 'Smooth Fit'),
                               checkboxInput('linear', 'Linear Fit'),
                               checkboxInput('lines', 'Individual Lines'),
                               style = "info"),
               bsCollapsePanel("Labels",
                               checkboxInput('custom_labels',"Custom Labels"),
                               textInput('title','Title'),
                               textInput('legend','Legend Title'),
                               textInput('xlab','X-Axis Label'),
                               textInput('ylab','Y-Axis Label'),
                               style = "info"),
               bsCollapsePanel("Export",
                               textInput('width','Export Width (px)', value = 2048),
                               textInput('height','Export Height (px)', value = 1536),
                               textInput('resolution','Resolution (px/in)', value = 300),
                               downloadButton('download','Download Plot'),
                               style = "info")

    ),


  ),
  mainPanel(
    plotlyOutput('plot', height = "800px")
  )
)
