ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "flatly"),
  
  titlePanel("Valheim"),
  
  tabsetPanel(
    
    # Tab for weapons overall. Choose a damage type and compare all weapons.
    
    tabPanel(
      
      "Weapons Comparison",
      
      tags$h2(fluidRow("Weapon 1")),
      # Top Row, inputs ---------
      fluidRow(
        ## Weapon selection ------
        column(
          width = 2,
          selectInput("weapon_input",
                      "Select Weapon",
                      weapons_list,
                      selected = "Porcupine")
        ),
        
        ## Weapon Type selection ------------
        # This filters the weapon selection
        column(
          width = 2,
          selectInput(
            "weapon_type_input",
            "Select Type of Weapon",
            weapon_type_list, # INCLUDE TOOLS WITH PLOT OF MATERIALS OR TEXT?
            selected = "All"
          )
        ),
        
        ## Weapon Material selection ----------
        # This filters the weapon selection
        column(
          width = 2,
          selectInput(
            "weapon_material_input",
            "Select Material",
            weapon_material_list, # INCLUDE TOOLS WITH PLOT OF MATERIALS OR TEXT?
            selected = "All"
          )
        ),
        
        ## Damage Type Selection --------------
        column(
          width = 2,
          selectInput(
            "damage_type_input",
            "Select Damage Type",
            damage_type_list, 
            selected = "All"
          )
        ),
        
        ## Apply filters -----------
        column(
          width = 2,
          actionButton("update", "Filter Weapons List")
        ),
        
        ## Reset filters -------------
        column(
          width = 2,
          actionButton("reset", "Reset Filters")
        )
      ),
      
      # Second row -----------
      fluidRow(
        
        ## weapon stats plot -----
        column(
          width = 8,
          plotlyOutput("weapon_stat_plot")
        ),
        
        ## weapon materials -------------
        column(
          width = 4,
          
          ### see crafting station type and level ----------
          fluidRow(
            column(
              width = 6,
              tags$b(textOutput("crafting_station_output"))
            ),
            column(
              width = 6,
              tags$b(textOutput("crafting_station_level_output"))
            )
          ),
          
          br(),
          
          ### choose item level----------
          radioButtons(
            "item_level_input",
            "Item Level",
            choices = c(1:4), #CHANGE TO DEPEND ON INPUT
            inline = TRUE
          ),
          
          ### see materials needed --------------
          tableOutput("weapon_material_table")
        )
      ),
      
      # Comparison ---------
      tags$h2(fluidRow("Weapon 2")),
      fluidRow(
        ## Weapon selection ------
        column(
          width = 2,
          #uiOutput("weapon_list")
          selectInput("weapon_input_2",
                      "Select Weapon",
                      weapons_list,
                      selected = "Blackmetal Sword")
        ),
        
        ## Weapon Type selection ------------
        # This filters the weapon selection
        column(
          width = 2,
          selectInput(
            "weapon_type_input_2",
            "Select Type of Weapon",
            weapon_type_list, # INCLUDE TOOLS WITH PLOT OF MATERIALS OR TEXT?
            selected = "All"
          )
        ),
        
        ## Weapon Material selection ----------
        # This filters the weapon selection
        column(
          width = 2,
          selectInput(
            "weapon_material_input_2",
            "Select Material",
            weapon_material_list, # INCLUDE TOOLS WITH PLOT OF MATERIALS OR TEXT?
            selected = "All"
          )
        ),
        
        ## Damage Type Selection --------------
        column(
          width = 2,
          selectInput(
            "damage_type_input_2",
            "Select Damage Type",
            damage_type_list, 
            selected = "All"
          )
        ),
        
        ## Apply filters ------------
        column(
          width = 2,
          actionButton("update_2", "Filter Weapons List")
        ),
        
        column(
          width = 1,
          actionButton("copy", "Copy Filters")
        ),
        
        ## Reset filters -------------
        column(
          width = 1,
          actionButton("reset_2", "Reset Filters")
        )
      ),
      
      # Second row -----------
      fluidRow(
        
        ## weapon stats plot-----
        column(
          width = 8,
          plotlyOutput("weapon_stat_plot_2")
        ),
        
        ## weapon materials -------------
        column(
          width = 4,
          
          # see crafting station type and level
          fluidRow(
            column(
              width = 6,
              tags$b(textOutput("crafting_station_output_2"))
            ),
            column(
              width = 6,
              tags$b(textOutput("crafting_station_level_output_2"))
            )
          ),
          
          br(),
          
          # choose item level
          radioButtons(
            "item_level_input_2",
            "Item Level",
            choices = c(1:4), #CHANGE TO DEPEND ON INPUT
            inline = TRUE
          ),
          
          # see materials needed 
          tableOutput("weapon_material_table_2")
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
        ),
      ),
      
      fluidRow(
        ## Graph of food stats ----------------
        plotlyOutput("food_stats_plot")
      ),
      
      fluidRow(
        radioButtons("food_item_input", tags$h2("Recipe"), food_recipe_list, inline = TRUE)
      ),
      
      fluidRow(
        ## Food Stats -----------------------
        column(
          width = 2,
          tableOutput("food_stats_table")
        ),
        
        ## Cooking Station(s) ------------
        column(
          width = 2,
          fluidRow(
            tags$b(tableOutput("food_crafting_station_outputs"))
          )
        ),
        
        ## Ingredients -------------------
        column(
          width = 2,
          fluidRow(
            # Ingredients table ----------
            tableOutput("food_crafting_table")
          )
        )
      )
    )
  )
)