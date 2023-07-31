ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "cyborg"),
  
  titlePanel("Valheim"),
  
  tabsetPanel(
    
    # Tab for weapons overall --------------
    # Choose a damage type and compare all weapons.
    tabPanel(
      "Weapons",
      
      ## Inputs ------------
      fluidRow(
        column(
          width = 2,
          selectInput("weapon_filter_options_input",
                      "Choose Filter Options",
                      c("Damage Type", "Material", "Weapon Type"))
        ),
        column(
          width = 2,
          selectInput("weapon_filter_input",
                      "Filter",
                      weapon_damage_types,
                      selected = "Total")
        )
      ),
      ## Plot (all_weapons_plot) ----------------
      fluidRow(
        column(
          width = 10,
          plotlyOutput("all_weapons_plot")
        ),
        column(
          width = 2,
          fluidRow(
            selectInput("weapon_choice_all_input", "",
                        weapons_list)
          ),
          fluidRow(
            column(
              width = 6,
              tags$b(textOutput("crafting_station_output_1"))
            ),
            column(
              width = 6,
              tags$b(textOutput("crafting_station_level_output_1"))
            )
          ),
          br(),
          fluidRow(
            radioButtons(
              "item_level_input_1",
              "Item Level",
              choices = c(1:4),
              inline = TRUE
            )
          ),
          fluidRow(
            tableOutput("weapon_material_table_1")
          )
        )
      )
    ),
    
    
    # Food tab ------------
    tabPanel(
      
      "Food",
      
      fluidRow(
        ## Food filter options ------------
        column(
          width = 2,
          radioButtons("food_filter_options_input",
                       "Choose Filter Options",
                       c("Main Stat", "Ingredients", "Biome"),
                       selected = "Main Stat")
        ),
        
        ## Food filter input -------------
        column(
          width = 3,
          selectInput("food_filter_input", "Filter",
                      food_type_list, selected = "Health")
        )
      ),
      
      fluidRow(
        ## Graph of food stats ----------------
        column(
          width = 10,
          plotlyOutput("food_stats_plot")
        ),
        column(
          width = 2,
          fluidRow(
            selectInput("food_item_input", tags$h2("Recipe"),
                        food_recipe_list)
          ),
          fluidRow(
            ## Food Stats -----------------------
            tableOutput("food_stats_table")
          ),
          ## Cooking Station(s) ------------
          fluidRow(
            tags$b(tableOutput("food_crafting_station_outputs"))
          ), 
          # Ingredients table ----------
          fluidRow(
            tableOutput("food_crafting_table")
          )
        )
      )
    )
  )
)
