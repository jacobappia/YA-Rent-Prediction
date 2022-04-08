library(shiny)
library(shinydashboard)
library(tidymodels)
library(ranger)
library(tidyverse)

model <- readRDS("Model/ya_rent_model.rds")


ui <- dashboardPage(
    skin = "green",
    dashboardHeader(title = "YA Rent Prediction App"),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem(
                "Rent",
                tabName = "rent_tab",
                icon = icon("money-bill-wave")
            )
        )
        
    ),
    dashboardBody(
    
        
        tabItem(
            tabName = "rent_tab",
            valueBoxOutput("rent_prediction", width = 6),
            box(
                "This app predicts the rent cost per month for Young American Realty students' apartment with the following features. 
                It will help ISU students to have an idea of the expected monthly cost of an apartment.
                The distance of the apartment is relative to the ISU BONE STUDENT CENTER."
            ),
            box(status="success", selectInput("v_parking", label = "Parking",
                            choices = c("Yes", "No"))),
            box(status="success", selectInput("v_utilities", label = "Utilities",
                            choices = c("Yes", "No"))),
            box(status="success", selectInput("v_type_of_laundry", label = "Type of Laundry",
                            choices = c("Coin", "In-Unit", "Neighboring Property"))),
            box(status="success", sliderInput("v_beds", label = "Beds",
                            min = 1, max = 9, value = 4)),
            box(status="success", sliderInput("v_bath", label = "Bath",
                            min = 1, max = 4.5, value = 2)),
            box(status="success", sliderInput("v_distance", label = "Distance (km)",
                            min = 0.05, max = 3.2, value = 0.4))
        )
    )
)


server <- function(input, output) { 
    
    output$rent_prediction <- renderValueBox({
        
        prediction1 <- predict(
            model,
            tibble("Beds" = 4,
                   "Bath" = 2,
                   "Parking" = "Yes",
                   "Utilities" = "No",
                   "Type.of.Laundry" = "In-Unit",
                   "distance" = 0.4)
        )
        prediction1$.pred
        prediction <- predict(
            model,
            tibble("Beds" = input$v_beds,
                   "Bath" = input$v_bath,
                   "Parking" = input$v_parking,
                   "Utilities" = input$v_utilities,
                   "Type.of.Laundry" = input$v_type_of_laundry,
                   "distance" = input$v_distance)
        ) 
        
        prediction_color <- if_else(prediction$.pred <= 400, "green", 
                                    if_else(prediction$.pred > 400 & prediction$.pred <= 600, "blue", "yellow"))
        
        valueBox(
            value = paste0("$ ",round(prediction$.pred, 2)),
            subtitle = "Predicted Rent",
            color = prediction_color,
            icon = icon("money-bill-wave")
        )
        
    })
    
}

shinyApp(ui, server)