library(shiny)
library(dplyr)
library(gt)
library(tidyr)

villagers_data = readr::read_rds(here::here("Data", "villagers_data.rds"))
items_data = readr::read_rds(here::here("Data", "items_data.rds"))

# Load in functions
source(here::here("Scripts", "02_select_villager.R"))


# Shiny App UI
ui = fluidPage(
  titlePanel(
    h1("Choose Your Fighter: Animal Crossing New Horizons", align = "center")),
  
  sidebarLayout(
    sidebarPanel(
      helpText("If you were a village in Animal Crossing, who would you be and what would be your first item?
               Select from the inputs below to find out."),
      
      selectInput("personality_vars",
                  label = "Choose your personality",
                  choices = unique(villagers_data$personality)),
      
      selectInput("species_vars",
                  label = "Choose your species",
                  choices = unique(villagers_data$species)),
      
      selectInput("item_vars",
                  label = "Choose your item category",
                  choices = unique(items_data$category))
      
    ),
    
    mainPanel(
      h6("A #TidyTuesday Project | Data from VillagerDB", align = "center"),
      gt::gt_output("animal_crossing_table"))
  ), 
)

server = function(input, output, session){
  
  observe({
    updateSelectInput(session, "personality_vars",
                      label = "Choose your personality",
                      choices = unique(villagers_data$personality)
                      )})
  
  observe({
    updateSelectInput(session, "species_vars",
                      label = "Choose your species",
                      choices = species_available(input$personality_vars, 
                                                  villagers_data),
                      selected = NULL)
    })
  
  observe({

      characters_available_df = characters_available(input$species_vars, 
                                                     input$personality_vars,
                                                     villagers_data)
      
      items_selected_df = select_item(input$item_vars, 
                                      items_data)
      
      output$animal_crossing_table = gt::render_gt({
        generate_character(characters_available_df, items_selected_df)
      })
    })
    
}

# Server Function


shinyApp(ui = ui, server = server)






