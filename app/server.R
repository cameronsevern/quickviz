library(shiny)
library(tidyverse)
library(plotly)
library(RColorBrewer)

loadRData <- function(fileName){
    #loads an RData file, and returns it
    load(fileName)
    get(ls()[ls() != "fileName"])
}


function(input, output, session) {

    dataset <- reactive({

        req(input$file1)

        if (grepl(".csv",input$file1$datapath)){
            df <- read.csv(input$file1$datapath)
        }
        else if (grepl(".RData",input$file1$datapath)){
            ext <- tools::file_ext(input$file1$datapath)
            validate(need(ext == "RData", "Please upload a valid RData file"))
            loadRData(input$file1$datapath)
        }

    })

    filteredDataset <- reactive({
        req(dataset())
        df <- dataset()
        if (input$filterBy != "All" & input$filterVal != "All"){
            df %>% filter(get(input$filterBy) == input$filterVal)
        }
        else {
            df
        }
    })

    observe({
        req(dataset())
        updateSelectInput(session, "filterBy",
                          choices = c("All",unique(names(dataset())))
        )

    })

    observe({
        req(dataset())
        if (input$filterBy != "All"){
          try({
            updateSelectInput(session, "filterVal",
                              choices = c("All",unique(dataset()[input$filterBy]))
            )
          }, silent = TRUE)

        }

    })

    observe({
        req(dataset())
        updateSelectInput(session, "y",
                          choices = names(dataset()))
        updateSelectInput(session, "x",
                          choices = names(dataset()))
        updateSelectInput(session, "color",
                          choices = c(None='.', names(dataset())))
        updateSelectInput(session, "size",
                          choices = c(None='.', names(dataset())))
        updateSelectInput(session, "facet_row",
                          choices = c(None='.', names(dataset())))
        updateSelectInput(session, "facet_col",
                          choices = c(None='.', names(dataset())))
        updateSelectInput(session, "frame",
                          choices = c(None='.', names(dataset())))
        updateSelectInput(session, "groupBy",
                          choices = c(None='.', names(dataset())))

    })


    output$plot <- renderPlotly({
        req(filteredDataset())
        req(input$y != "None")
        df <- filteredDataset()
        p <- ggplot(data = df,
                    mapping = aes_string(x=input$x, y=input$y))

        if(input$scatter){
            p <- p + geom_point()
        }
        if(input$boxplot){
            p <- p + geom_boxplot()
        }

        if(input$groupBy != '.'){
          p <- p + geom_line(inherit.aes = FALSE,
                             mapping = aes_string(x=input$x,
                                                  y=input$y,
                                                  group = input$groupBy))
        }
        if(input$flipScale){
          direction <- -1
        }
        else{
          direction <- 1
        }

        if (input$color != '.'){
          colVar <- paste0("`",input$color,"`")
          print(colVar)
          print(class(df[[input$color]]))
          if (class(df[[input$color]]) == "numeric" |
              class(df[[input$color]]) == "matrix" |
              class(df[[input$color]]) == "array"  |
              class(df[[input$color]]) == "integer"){
            p <- p + aes_string(color=colVar)
            if (input$colorScale != "Auto"){
              p <- p + scale_color_distiller(palette = input$colorScale, direction = direction)
            }
          }
          else{
            p <- p + aes_string(color=colVar)
          }
        }


        if (input$size != '.'){
            p <- p + aes_string(size=input$size)
        }

        if (input$frame != '.'){
            p <- p + aes_string(frame=input$frame)
        }

        facets <- paste(input$facet_row, '~', input$facet_col)

        if (facets != '. ~ .'){
            p <- p + facet_grid(facets)
        }

        if (input$jitter){
            p <- p + geom_jitter(width = input$jitterWidth)
        }
        if (input$smooth){
            p <- p + geom_smooth(se = F)
        }
        if (input$linear){
            p <- p + geom_smooth(method = 'lm', se = F)
        }

        if(input$custom_labels){
            p <- p + xlab(input$xlab) +
                ylab(input$ylab) +
                ggtitle(as.character(input$title)) +
                labs(color = input$legend) +
                theme(plot.title = element_text(face = "bold",
                                                size = 20))
        }
        p <- p + get(input$plotTheme)()

        finalplot <<- p
        try({
          print(ggplotly(p))
        }, silent = TRUE)


    })
    plotInput = function() {
        finalplot
    }
    output$download <- downloadHandler(
        filename = "plot.png",
        content = function(file) {
            png(file, width = as.numeric(input$width),
                height = as.numeric(input$height),
                res = as.numeric(input$resolution))
            print(plotInput())
            dev.off()
        }
    )
    session$onSessionEnded(function() {
        stopApp()
    })

}

