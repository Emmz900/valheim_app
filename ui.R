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
          radioButtons("weapon_filter_options_input",
                       "Choose Filter Options",
                       c("Damage Type", "Material", "Weapon Type"))
        ),
        column(
          width = 2,
          selectInput("weapon_filter_input",
                      "Filter",
                      weapon_damage_types,
                      selected = "Total")
        ),
        
        column(
          width = 2,
          offset = 6,
          tags$h2("Weapon")
        )
      ),
      ## Plot (all_weapons_plot) ----------------
      fluidRow(
        column(
          width = 10,
          plotlyOutput("all_weapons_plot")
        ),
        ## item information -------------
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
    
    # Armor tab -----------
    
    tabPanel(
      "Armor",
      
      fluidRow(
        ## Workbench -------------
        column(
          width = 2,
          selectInput("workbench_input", "Workbench Level", c(1:6))
        ),
        ## Forge -----------------
        column(
          width = 2,
          selectInput("forge_input", "Forge Level", c(0:7))
        ),
        ## Black forge -----------
        column(
          width = 2,
          selectInput("black_forge_input", "Black Forge Level", c(0:3))
        ),
        ## Galdr table ------------
        column(
          width = 2,
          selectInput("galdr_input", "Galdr Table Level", c(0:3))
        ),
        ## Refresh button
        column(
          width = 2,
          actionButton("armor_refresh", "Apply Filters")
        )
      ),
      
      fluidRow(
        ## Chest --------------
        column(
          width = 6,
          "Chest",
          plotlyOutput("chest_table")
        ),
        ## Legs ----------
        column(
          width = 6,
          "Legs",
          plotlyOutput("legs_table")
        )
      ),
      
      fluidRow(
        ## Helmet --------
        column(
          width = 6,
          "Helmet",
          plotlyOutput("helmet_table")
        ),
        ## Cape ----------
        column(
          width = 6,
          "Cape",
          plotlyOutput("cape_table")
        )
      ),
      
      ## Summary --------
      fluidRow(
        "Summary"
      ),
      fluidRow(
        column(
          width = 3,
          selectInput("chest_input", "Chosen Chest", chest_list)
        ),
        
        column(
          width = 3,
          selectInput("legs_input", "Chosen Legs", legs_list)
        ),
        column(
          width = 3,
          selectInput("helmet_input", "Chosen Helmet", helmet_list)
        ),
        column(
          width = 3,
          selectInput("cape_input", "Chosen Cape", cape_list)
        )
      ),
      
      fluidRow(
        column(
          width = 2,
          "Total Armor",
          tableOutput("total_armor")
        )
        # Set Bonus info!
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
        ),
        
        column(
          width = 2,
          offset = 5,
          tags$h2("Recipe")
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
            selectInput("food_item_input", "",
                        food_recipe_list)
          ),
          # fluidRow(
          #   ## Food Stats
          #   tableOutput("food_stats_table")
          # ),
          ## Cooking Station(s) ------------
          fluidRow(
            tags$b(textOutput("food_crafting_station_outputs")),
            tags$b(textOutput("food_crafting_station_level"))
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
