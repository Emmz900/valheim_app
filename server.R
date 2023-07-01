server <- function(input, output, session) {
  
  weapon_input <- reactive({str_to_lower(input$weapon_input)})
  weapon_type_input <- reactive({str_to_lower(input$weapon_type_input)})
  weapon_material_input <- reactive({str_to_lower(input$weapon_material_input)})
  
  observeEvent(input$weapon_type_input, {
    
      filtered_weapons <- 
        weapons_joined %>%
        {if(weapon_type_input != "all") filter(., type == weapon_type_input)} %>%
        {if(weapon_material_input != "all") filter(., material == weapon_material_input)}  %>% 
        distinct(item) %>%
        pull() %>% 
        sort()
    
    # if(weapon_type_input == "all" & weapon_material_input == "all"){
    #   weapons_joined %>%
    #     distinct(item) %>%
    #     pull()
    # } else if (weapon_type_input != "all") {
    #   weapons_joined %>%
    #     filter(type == weapon_type_input) %>%
    #     distinct(item) %>%
    #     pull()
    # } else if (weapon_material_input == "all"){
    #   weapons_joined %>%
    #     filter(material == weapon_material_input) %>%
    #     distinct(item) %>%
    #     pull()
    # }
    
    filtered_materials <-
      weapons_joined %>%
      {if(weapon_type_input != "all") filter(., type == weapon_type_input)} %>% 
      mutate(material = str_to_title(material)) %>%
      distinct(material) %>%
      pull() %>%
      append("All") %>%
      sort()
    
    updateSelectInput(session, inputId = "weapon_input", choices = filtered_weapons)
    updateSelectInput(session, inputID = "weapon_material_input", choices = filtered_materials)
  })
  
  observeEvent(input$weapon_material_input, {
    
    filtered_weapons <- 
      weapons_joined %>%
      {if(weapon_type_input != "all") filter(., type == weapon_type_input)} %>%
      {if(weapon_material_input != "all") filter(., material == weapon_material_input)}  %>% 
      distinct(item) %>%
      pull() %>% 
      sort()
    
    # filtered_weapons <-
    #   if(input$weapon_type_input == "All" & input$weapon_material_input == "All"){
    #     weapons_joined %>%
    #       distinct(item) %>%
    #       pull()
    #   } else if (input$weapon_material_input == "All") {
    #     weapons_joined %>%
    #       filter(type == input$weapon_type_input) %>%
    #       distinct(item) %>%
    #       pull()
    #   } else if (input$weapon_type_input == "All"){
    #     weapons_joined %>%
    #       filter(material == input$weapon_material_input) %>%
    #       distinct(item) %>%
    #       pull()
    #   }
    filtered_types <-
      weapons_joined %>%
      filter(!type %in% c("upgrade", "tool", "shield", "magic", "weapon")) %>%
      {if(weapon_material_input != "all") filter(material == weapon_material_input)} %>% 
      mutate(type = str_to_title(type)) %>%
      distinct(type) %>%
      pull() %>%
      append("All") %>%
      sort()
    
    # if(input$weapon_material_input == "All"){
    #   
    # } else {
    #   weapons_joined %>%
    #     filter(material == input$weapon_material_input) %>%
    #     filter(!type %in% c("upgrade", "tool", "shield", "magic", "weapon")) %>%
    #     mutate(type = str_to_title(type)) %>%
    #     distinct(type) %>%
    #     pull() %>%
    #     append("All") %>%
    #     sort()
    # }
    updateSelectInput(session, inputId = "weapon_input", choices = filtered_weapons)
    updateSelectInput(session, inputID = "weapon_type_input", choices = filtered_types)
  })
  
  # #output$weapon_list <- renderUI({
  #   weapons_list <- reactive({
  #     if(input$weapon_type_input == "All" & input$weapon_material_input == "All"){
  #       weapons_joined %>% 
  #         distinct(item) %>% 
  #         pull()
  #     } else if (input$weapon_material_input == "All") {
  #       weapons_joined %>% 
  #         filter(type == input$weapon_type_input) %>% 
  #         distinct(item) %>% 
  #         pull()
  #     } else if (input$weapon_type_input == "All"){
  #       weapons_joined %>% 
  #         filter(material == input$weapon_material_input) %>% 
  #         distinct(item) %>% 
  #         pull()
  #     }
  #   
  #   selectInput("weapon_input",
  #               "Select Weapon",
  #               weapons_list)
  # })
  # 
  # 
  # output$weapon_type_list <- renderUI({
  #   weapon_type_list <- 
  #     if(input$weapon_material_input == "All"){
  #       weapons_joined %>% 
  #         filter(!type %in% c("upgrade", "tool", "shield", "magic", "weapon")) %>% 
  #         mutate(type = str_to_title(type)) %>% 
  #         distinct(type) %>% 
  #         pull() %>% 
  #         append("All") %>% 
  #         sort()
  #     } else {
  #       weapons_joined %>% 
  #         filter(material == input$weapon_material_input) %>% 
  #         filter(!type %in% c("upgrade", "tool", "shield", "magic", "weapon")) %>% 
  #         mutate(type = str_to_title(type)) %>% 
  #         distinct(type) %>% 
  #         pull() %>% 
  #         append("All") %>% 
  #         sort()
  #     }
  #   
  #   selectInput(
  #     "weapon_type_input",
  #     "Select Type of Weapon",
  #     weapon_type_list, # INCLUDE TOOLS WITH PLOT OF MATERIALS OR TEXT?
  #     selected = "All"
  #   )
  #   
  # })
  # 
  # output$weapon_material_list <- renderUI({
  #   weapon_material_list <- 
  #     if(input$weapon_type_input == "All"){
  #       weapons_joined %>% 
  #         mutate(material = str_to_title(material)) %>% 
  #         distinct(material) %>% 
  #         pull() %>% 
  #         append("All") %>% 
  #         sort()
  #     } else {
  #       weapons_joined %>% 
  #         mutate(material = str_to_title(material)) %>% 
  #         filter(type == input$weapon_type_input) %>% 
  #         distinct(material) %>% 
  #         pull() %>% 
  #         append("All") %>% 
  #         sort()
  #     }
  #   
  #   selectInput(
  #     "weapon_material_input",
  #     "Select Material",
  #     weapon_material_list, # INCLUDE TOOLS WITH PLOT OF MATERIALS OR TEXT?
  #     selected = "All"
  #   )
  # })
  
  filtered_weapons <- reactive({
    weapons_crafting_clean %>% 
      filter(item == input$weapon_input)
  })
  
  # Crafting Station Type - TEXT
  output$crafting_station_output <- renderText({
    filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      distinct(crafting_station) %>% 
      pull()
  })
  
  # Crafting Station Level - TEXT
  output$crafting_station_level_output <- renderText({
    filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      distinct(crafting_station_level) %>% 
      pull()
  })
  
  # ROUND MATERIAL AMOUNT TO 0 DECIMAL PLACES
  output$weapon_material_table <- renderTable({
    filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      select(material, amount_of_material)
  })
  
  # IMPROVE PLOT COLOURS AND SIZE
  output$weapon_stat_plot <- renderPlot({
    #if(input$weapon_input %in% weapons_list) {
    #plot <- 
    weapons_data_clean %>% 
      filter(name == input$weapon_input) %>% 
      mutate(min_max = 
               case_when(
                 str_detect(damage_type, "_min") ~ "min",
                 str_detect(damage_type, "_max") ~ "max",
                 str_detect(damage_type, "_diff") ~ "diff"
               ),
             damage_type = str_remove(damage_type, "_min|_max|_diff")
      ) %>% 
      mutate(min_max = coalesce(min_max, "min")) %>% 
      filter(min_max != "max") %>% 
      ggplot(aes(damage_type, values, fill = min_max)) +
      geom_col(show.legend = FALSE) +
      scale_fill_manual(values = c(
        "diff" = "green4",
        "min" = "green3"
      )) +
      theme_classic()
    #} else {
    #  plot <- ggplot(aes(input$weapon_input)) +
    #    geom_bar()
    #}
    # plot
  })
  
}