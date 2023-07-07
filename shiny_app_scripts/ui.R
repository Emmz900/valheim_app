ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "flatly"),
  
  titlePanel("Valheim"),
  
  tabsetPanel(
    tabPanel(
      
      "Weapons",
      
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
          actionButton("reset", "Reset Filters")
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
        column(
          width = 2,
          radioButtons("food_filter_input",
                             "Choose Filter Options",
                             c("Main Stat", "Ingredients", "Biome"),
                             selected = "Main Stat")
        ),
        
        # food type input
        column(
          width = 3,
          selectInput("filter_input", "Filter",
                      str_to_upper(food_type_list), selected = "Health")
        ),
      ),
      
      fluidRow(
        # graph of stats
        plotlyOutput("food_stats_plot")
      ),
      
      fluidRow(
        # cooking station
        
        # level
        
        column(
          width = 3,
          fluidRow(
            # select food
            
            # ingredients table
          )
        )
      )
    )
  )
)