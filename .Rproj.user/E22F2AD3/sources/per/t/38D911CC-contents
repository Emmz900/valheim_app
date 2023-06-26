ui <- fluidPage(
  
  titlePanel("Valheim"),
  
  tabsetPanel(
    tabPanel(
      
      "Tools and Weapons",
      
      # weapon selection ------
      fluidRow(
        selectInput(
          "weapon_input",
          "Select Tool or Weapon",
          weapons_list # INCLUDE TOOLS WITH PLOT OF MATERIALS OR TEXT?
        )
        
        # add a filter weapon by type -------
        
        # add a filter weapon by material ---------
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