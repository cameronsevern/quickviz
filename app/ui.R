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
                               selectInput('groupBy', 'Connect Points By',
                                           c(None='.')),
                               style = "info"),
               bsCollapsePanel("Plot Type",
                               checkboxInput('scatter', 'Scatter', value = T),
                               checkboxInput('boxplot', 'Box'),
                               checkboxInput('jitter', 'Jitter'),
                               checkboxInput('smooth', 'Smooth Fit'),
                               checkboxInput('linear', 'Linear Fit'),
                               style = "info"),
               bsCollapsePanel("Aesthetics",
                               selectInput("plotTheme", "Plot Theme",
                                           c("Gray" = "theme_gray",
                                             "BW" = "theme_bw",
                                             "Line Draw" = "theme_bw",
                                             "Light" = "theme_light",
                                             "Minimal" = "theme_minimal",
                                             "Classic" = "theme_classic",
                                             "Void" = "theme_void"),
                                           selected = "theme_light"
                               ),
                               selectInput("colorScale", "Color Scale",
                                           c("Auto","Spectral","Blues", "BuGn", "BuPu", "GnBu",
                                             "Greens", "Greys", "Oranges",
                                             "OrRd", "PuBu", "PuBuGn", "PuRd",
                                             "Purples", "RdPu", "Reds", "YlGn",
                                             "YlGnBu", "YlOrBr", "YlOrRd"
                                           )),
                               checkboxInput("flipScale","Flip Scale"),
                               numericInput(inputId = "plotPointSize",
                                            label = "Constant Point Size",
                                            value = 1,
                                            min = 0,
                                            max = 10,
                                            step = 0.1),
                               numericInput(inputId = "jitterWidth",
                                            label = "Jitter Spread",
                                            value = 0.15,
                                            min = 0,
                                            max = 1,
                                            step = 0.05),
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
