#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Install and load required packages
install.packages("shiny")
install.packages("ggplot2")
install.packages("cluster")
install.packages("factoextra")
install.packages("dplyr")
install.packages("plotly")

library(shiny)
library(ggplot2)
library(cluster)
library(factoextra)
library(dplyr)
library(plotly)

# Define the UI Layout
ui <- fluidPage(
  titlePanel("Cluster Profiling Software"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload Data (CSV file)"),
      numericInput("k_clusters", "Number of Clusters (k)", 3, min = 2, max = 15),
      actionButton("cluster_button", "Cluster Data"),
      actionButton("reset_button", "Reset"),
      selectInput("cluster_variable", "Cluster Variable", ""),
      actionButton("profile_clusters", "Cluster Profiling"),
      selectInput("x_variable", "X-Axis Variable for Plot", ""),
      selectInput("y_variable", "Y-Axis Variable for Plot", ""),
      actionButton("plot_button", "Generate Scatter Plot"),
      actionButton("boxplot_button", "Generate Box Plot"),
      actionButton("barplot_button", "Generate Bar Plot")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Data Summary", verbatimTextOutput("data_summary")),
        tabPanel("Cluster Visualization", plotlyOutput("cluster_plot")),
        tabPanel("Cluster Profiling", tableOutput("cluster_profile")),
        tabPanel("Custom Plots", plotlyOutput("custom_plot"))
      )
    )
  )
)

# Define the Server Logic
server <- function(input, output, session) {
  data <- reactive({
    req(input$file)
    customers <- read.csv(input$file$datapath)

    # Remove CustomerID and convert Genre to factor
    customers$CustomerID <- NULL
    customers$Genre <- NULL

    # Ensure the remaining columns are numeric
    for (col in colnames(customers)) {
      customers[[col]] <- as.numeric(customers[[col]])
    }

    # Remove rows with missing values
    customers <- na.omit(customers)

    updateSelectInput(session, "cluster_variable", choices = c("", names(customers)))
    updateSelectInput(session, "x_variable", choices = c("", names(customers)))
    updateSelectInput(session, "y_variable", choices = c("", names(customers)))

    customers
  })

  clustered_data <- reactiveVal(NULL)

  output$cluster_plot <- renderPlotly({
    if (!is.null(clustered_data())) {
      gg <- fviz_cluster(clustered_data(), data = data(), geom = "point")
      ggplotly(gg)
    }
    
  })
 
   # Display data summary
  output$data_summary <- renderPrint({
    str(data())
    summary(data())
  })
    
  output$cluster_profile <- renderTable({
    if (!is.null(clustered_data())) {
      cluster_profile <- data() %>%
        mutate(Cluster = as.factor(clustered_data()$cluster)) %>%
        group_by(Cluster) %>%
        summarise_all(mean)
      cluster_profile
    }
  })

  output$custom_plot <- renderPlotly({
    if (!is.null(clustered_data())) {
      x_var <- input$x_variable
      y_var <- input$y_variable
      if (!is.null(x_var) && !is.null(y_var) && x_var != "" && y_var != "") {
        gg <- ggplot(data(), aes_string(x = x_var, y = y_var, color = as.factor(clustered_data()$cluster))) +
          geom_point() +
          labs(x = x_var, y = y_var) +
          theme_minimal()
        ggplotly(gg)
      }
    }
  })

  observeEvent(input$cluster_button, {
    k <- input$k_clusters
    customer_sc <- as.data.frame(scale(data()))
    kmeans_result <- kmeans(customer_sc, centers = k, nstart = 25)
    clustered_data(kmeans_result)
  })

  observeEvent(input$reset_button, {
    updateNumericInput(session, "k_clusters", value = 3)
    updateSelectInput(session, "cluster_variable", choices = c(""))
    updateSelectInput(session, "x_variable", choices = c(""))
    updateSelectInput(session, "y_variable", choices = c(""))
    clustered_data(NULL)
    output$cluster_plot <- renderPlotly(NULL)
    output$cluster_profile <- renderTable(NULL)
    output$custom_plot <- renderPlotly(NULL)
  })
}

# Run the Shiny App
shinyApp(ui = ui, server = server)
