server <- function(input, output, session) {
  
  observeEvent(input$update, {
    weapons_list <- weapons_joined %>% 
      {if(input$weapon_type_input != "All") 
        filter(., type == input$weapon_type_input)
        else 
          filter(., !is.na(type))} %>%
      {if(input$weapon_material_input != "All") 
        filter(., material == input$weapon_material_input)
        else 
          filter(., !is.na(type))}  %>% 
      {if(input$damage_type_input != "All") 
        filter(., str_detect(damage_type, as.character(input$damage_type_input)))
        else 
          filter(., !is.na(type))} %>% 
      filter(!is.na(values)) %>% 
      distinct(item) %>% 
      pull() %>% 
      sort()
    
    updateSelectInput(session, inputId = "weapon_input", choices = weapons_list)
  })
  
  # If weapon type input is changed, update weapon list ------
  # observeEvent(input$weapon_type_input, {
  #   weapons_list <- 
  #     weapons_joined %>%
  #     {if(input$weapon_type_input != "All") # filter by weapon input
  #       filter(., type == input$weapon_type_input) 
  #       else # keep everything / do nothing
  #         filter(., !is.na(type))} %>%
  #     #browser()
  #     {if(input$weapon_material_input != "All") 
  #       filter(., material == input$weapon_material_input) 
  #       else 
  #         filter(., !is.na(type))}  %>% 
  #     {if(input$damage_type_input != "All") 
  #       filter(., str_detect(damage_type, as.character(input$damage_type_input)))
  #       else 
  #         filter(., !is.na(type))} %>% 
  #     distinct(item) %>%
  #     pull() %>% 
  #     sort()
  #   
  #   updateSelectInput(session, inputId = "weapon_input", choices = weapons_list)
  # })
  # 
  # # If weapon material input is changed, update weapon list ------
  # observeEvent(input$weapon_material_input, {
  #   
  #   weapons_list <- 
  #     weapons_joined %>%
  #     {if(input$weapon_type_input != "All") 
  #       filter(., type == input$weapon_type_input)
  #       else 
  #         filter(., !is.na(type))} %>%
  #     {if(input$weapon_material_input != "All") 
  #       filter(., material == input$weapon_material_input)
  #       else 
  #         filter(., !is.na(type))}  %>% 
  #     {if(input$damage_type_input != "All") 
  #       filter(., str_detect(damage_type, as.character(input$damage_type_input)))
  #       else 
  #         filter(., !is.na(type))} %>% 
  #     distinct(item) %>%
  #     pull() %>% 
  #     sort()
  #   
  #   updateSelectInput(session, inputId = "weapon_input", choices = weapons_list)
  # })
  # 
  # observeEvent(input$damage_type_input, {
  #   weapons_list <- weapons_data_clean %>% 
  #     {if(input$weapon_type_input != "All") 
  #       filter(., type == input$weapon_type_input)
  #       else 
  #         filter(., !is.na(type))} %>%
  #     {if(input$weapon_material_input != "All") 
  #       filter(., material == input$weapon_material_input)
  #       else 
  #         filter(., !is.na(type))}  %>% 
  #     {if(input$damage_type_input != "All") 
  #       filter(., str_detect(damage_type, as.character(input$damage_type_input)))
  #       else 
  #         filter(., !is.na(type))} %>% 
  #     filter(!is.na(values)) %>% 
  #     distinct(name) %>% 
  #     pull() %>% 
  #     sort()
  #   
  #   updateSelectInput(session, inputId = "weapon_input", choices = weapons_list)
  # })
  
  # Filter the weapon data based on weapon input ---------------
  filtered_weapons <- reactive({
    weapons_crafting_clean %>% 
      filter(item == input$weapon_input)
  })
  
  # Crafting Station Type - TEXT -----------
  output$crafting_station_output <- renderText({
    filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      distinct(crafting_station) %>% 
      pull() %>% 
      str_to_title()
  })
  
  # Crafting Station Level - TEXT --------------
  output$crafting_station_level_output <- renderText({
    level <- filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      distinct(crafting_station_level) %>% 
      pull() %>% 
      str_to_title()
    
    paste("Level: ", level)
  })
  
  # Table of materials and amounts -------------
  output$weapon_material_table <- renderTable({
    filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      mutate(amount_of_material = format(amount_of_material, nsmall = 0)) %>% 
      select(material, amount_of_material) %>% 
      rename("Material" = material, "Amount of Material" = amount_of_material)
    
  })
  
  # Plot of damage types ----------------
  # IMPROVE PLOT COLOURS AND SIZE
  # Broke with str_to_lower
  output$weapon_stat_plot <- renderPlot({
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
      scale_y_continuous(breaks = seq(0, 220, 20), limits = c(0, 220)) +
      theme_classic() +
      labs(
        x = "Damage Type",
        y = "Damage Values"
      ) #+ 
    #theme(axis.title = element_text(size = 12))
    
  })
  
  # Part 2 ----------
  # If weapon type input is changed, update weapon list ------
  observeEvent(input$weapon_type_input_2, {
    
    weapons_list <- 
      weapons_joined %>%
      {if(input$weapon_type_input_2 != "All") # filter by weapon input
        filter(., type == input$weapon_type_input_2) 
        else # keep everything / do nothing
          filter(., !is.na(type))} %>%
      #browser()
      {if(input$weapon_material_input_2 != "All") 
        filter(., material == input$weapon_material_input_2) 
        else 
          filter(., !is.na(type))}  %>% 
      distinct(item) %>%
      pull() %>% 
      sort()
    
    updateSelectInput(session, inputId = "weapon_input_2", choices = weapons_list)
  })
  
  # If weapon material input is changed, update weapon list ------
  observeEvent(input$weapon_material_input_2, {
    
    weapons_list <- 
      weapons_joined %>%
      {if(input$weapon_type_input_2 != "All") 
        filter(., type == input$weapon_type_input_2)
        else 
          filter(., !is.na(type))} %>%
      {if(input$weapon_material_input_2 != "All") 
        filter(., material == input$weapon_material_input_2)
        else 
          filter(., !is.na(type))}  %>% 
      distinct(item) %>%
      pull() %>% 
      sort()
    
    updateSelectInput(session, inputId = "weapon_input_2", choices = weapons_list)
  })
  

  # Filter the weapon data based on weapon input ---------------
  filtered_weapons_2 <- reactive({
    weapons_crafting_clean %>% 
      filter(item == input$weapon_input_2)
  })
  
  # Crafting Station Type - TEXT -----------
  output$crafting_station_output_2 <- renderText({
    filtered_weapons_2() %>% 
      filter(upgrade_level == input$item_level_input_2) %>% 
      distinct(crafting_station) %>% 
      pull() %>% 
      str_to_title()
  })
  
  # Crafting Station Level - TEXT --------------
  output$crafting_station_level_output_2 <- renderText({
    level <- filtered_weapons_2() %>% 
      filter(upgrade_level == input$item_level_input_2) %>% 
      distinct(crafting_station_level) %>% 
      pull() %>% 
      str_to_title()
    
    paste("Level: ", level)
  })
  
  # Table of materials and amounts -------------
  output$weapon_material_table_2 <- renderTable({
    filtered_weapons_2() %>% 
      filter(upgrade_level == input$item_level_input_2) %>% 
      mutate(amount_of_material = format(amount_of_material, nsmall = 0)) %>% 
      select(material, amount_of_material) %>% 
      rename("Material" = material, "Amount of Material" = amount_of_material)
    
  })
  
  # Plot of damage types ----------------
  output$weapon_stat_plot_2 <- renderPlot({
    weapons_data_clean %>% 
      filter(name == input$weapon_input_2) %>% 
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
      scale_y_continuous(breaks = seq(0, 220, 20), limits = c(0, 220)) +
      theme_classic() +
      labs(
        x = "Damage Type",
        y = "Damage Values"
      ) #+ 
    #theme(axis.title = element_text(size = 12))
    
  })
  
}

