ui <- fluidPage(
  
  titlePanel("Valheim"),
  
  tabsetPanel(
    tabPanel(
      
      "Weapons",
      
      # weapon selection ------
      fluidRow(
        column(
          width = 3,
          #uiOutput("weapon_list")
          selectInput("weapon_input",
                      "Select Weapon",
                      weapons_list,
                      selected = "club")
          ),
        
        column(
          width = 3,
          #uiOutput("weapon_type_list")
          selectInput(
            "weapon_type_input",
            "Select Type of Weapon",
            weapon_type_list, # INCLUDE TOOLS WITH PLOT OF MATERIALS OR TEXT?
            selected = "All"
          )
          ),
        
        column(
          width = 3,
          #uiOutput("weapon_material_list")
          selectInput(
            "weapon_material_input",
            "Select Material",
            weapon_material_list, # INCLUDE TOOLS WITH PLOT OF MATERIALS OR TEXT?
            selected = "All"
          )
          )
      ),
      
      
      fluidRow(
        
        # weapon stats -----
        column(
          width = 8,
          plotOutput("weapon_stat_plot")
        ),
        
        # weapon materials -------------
        column(
          width = 4,
          
          # see crafting station type and level
          fluidRow(
            column(
              width = 6,
              textOutput("crafting_station_output")
            ),
            column(
              width = 6,
              textOutput("crafting_station_level_output")
            )
          ),
          
          
          # choose item level
          radioButtons(
            "item_level_input",
            "Item Level",
            choices = c(1:4), #CHANGE TO DEPEND ON INPUT
            inline = TRUE
          ),
          
          # see materials needed 
          tableOutput("weapon_material_table")
        )
      )
      
    )
  )
  
)