server <- function(input, output, session) {
  
  observeEvent(input$weapon_type_input, {
    
    weapons_list <- 
      weapons_joined %>%
      {if(input$weapon_type_input != "All") 
        filter(., type == str_to_lower(input$weapon_type_input)) 
        else 
          filter(., !is.na(type))} %>%
      #browser()
      {if(input$weapon_material_input != "All") 
        filter(., material == str_to_lower(input$weapon_material_input)) 
        else 
          filter(., !is.na(type))}  %>% 
      distinct(item) %>%
      pull() %>% 
      sort()
    
    # filtered_materials <-
    #   weapons_joined %>%
    #   {if(input$weapon_type_input != "All") 
    #     filter(., type == str_to_lower(input$weapon_type_input))
    #     else 
    #       filter(., !is.na(type))} %>% 
    #   mutate(material = str_to_title(material)) %>%
    #   distinct(material) %>%
    #   pull() %>%
    #   append("All") %>%
    #   sort()
    
    updateSelectInput(session, inputId = "weapon_input", choices = weapons_list)
    #updateSelectInput(session, inputID = "weapon_material_input", choices = filtered_materials)
  })
  
  observeEvent(input$weapon_material_input, {
    
    weapons_list <- 
      weapons_joined %>%
      {if(input$weapon_type_input != "All") 
        filter(., type == str_to_lower(input$weapon_type_input))
        else 
          filter(., !is.na(type))} %>%
      {if(input$weapon_material_input != "All") 
        filter(., material == str_to_lower(input$weapon_material_input))
        else 
          filter(., !is.na(type))}  %>% 
      distinct(item) %>%
      pull() %>% 
      sort()
    updateSelectInput(session, inputId = "weapon_input", choices = weapons_list)
  })
  
  #   observeEvent(input$weapon_material_input, {   
  #   filtered_types <-
  #     weapons_joined %>%
  #     filter(!type %in% c("upgrade", "tool", "shield", "magic", "weapon")) %>%
  #     {if(input$weapon_material_input != "All") 
  #       filter(material == str_to_lower(input$weapon_material_input))
  #       else 
  #         filter(., !is.na(type))} %>% 
  #     mutate(type = str_to_title(type)) %>%
  #     distinct(type) %>%
  #     pull() %>%
  #     append("All") %>%
  #     sort()
  #   
  #   #updateSelectInput(inputID = "weapon_type_input", choices = filtered_types)
  # })
  
  
  filtered_weapons <- reactive({
    weapons_crafting_clean %>% 
      filter(item == str_to_lower(input$weapon_input))
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

