server <- function(input, output, session) {
  
  # Weapon 1 ----------------------
  ## Filter weapons list on button press ----------
  observeEvent(input$update, {
    weapons_list <- weapons_joined %>% 
      {if(input$weapon_type_input != "All") # if weapon type input -> filter
        filter(., type == input$weapon_type_input)
        else 
          filter(., !is.na(type))} %>%
      {if(input$weapon_material_input != "All") # if material input -> filter
        filter(., material == input$weapon_material_input)
        else 
          filter(., !is.na(type))}  %>% 
      {if(input$damage_type_input != "All") # if damage type input -> filter
        filter(., str_detect(damage_type, as.character(input$damage_type_input)))
        else 
          filter(., !is.na(type))} %>% 
      filter(!is.na(values)) %>% 
      distinct(item) %>% 
      pull() %>% 
      sort()
    
    updateSelectInput(session, inputId = "weapon_input", choices = weapons_list)
  })
  
  ### Reset filters -----------
  observeEvent(input$reset, {
    updateSelectInput(session, inputId = "weapon_type_input", selected = "All")
    updateSelectInput(session, inputId = "weapon_material_input", selected = "All")
    updateSelectInput(session, inputId = "damage_type_input", selected = "All")
    
    weapons_list <- weapons_joined %>% 
      distinct(item) %>% 
      pull() %>% 
      sort()
    
    updateSelectInput(session, inputId = "weapon_input", choices = weapons_list)
  })
  
  ## Filter the weapon data based on weapon input ---------------
  filtered_weapons <- reactive({
    weapons_crafting_clean %>% 
      filter(item == input$weapon_input)
  })
  
  ## Crafting Station Type - TEXT -----------
  output$crafting_station_output <- renderText({
    filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      distinct(crafting_station) %>% 
      pull() %>% 
      str_to_title()
  })
  
  ## Crafting Station Level - TEXT --------------
  output$crafting_station_level_output <- renderText({
    level <- filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      distinct(crafting_station_level) %>% 
      pull() %>% 
      str_to_title()
    
    paste("Level: ", level)
  })
  
  ## Update item level buttons depending on weapon selected --------------
  observeEvent(input$weapon_input, {
    choices <- filtered_weapons() %>% 
      distinct(upgrade_level) %>% 
      pull()
    updateRadioButtons(inputId = "item_level_input", choices = choices, inline = TRUE)
  })
  
  
  ## Table of materials and amounts -------------
  output$weapon_material_table <- renderTable({
    filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      mutate(amount_of_material = format(amount_of_material, nsmall = 0)) %>% 
      select(material, amount_of_material) %>% 
      rename("Material" = material, "Amount of Material" = amount_of_material)
    
  })
  
  ## PLOT of damage types ----------------
  # IMPROVE PLOT COLOURS AND SIZE
  output$weapon_stat_plot <- renderPlotly({
    
    p <- weapons_data_clean %>% 
      filter(name == input$weapon_input,
             min_max != "max") %>% 
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
        y = "Damage Values (Min-Max)"
      ) 
    
    p <- p %>% style(
      #text = ~paste(damage_type, ": ", round(values, 0)),
      #hoverinfo = text,
      hovertemplate = "%{x}: %{y:.0f}<extra></extra>"
    )
    p <- p %>% layout(showlegend = FALSE)
    
    ggplotly(p)
  })
  
  # Weapon 2 ----------
  ## If weapon type input is changed, update weapon list ------
  observeEvent(input$update_2, {
    weapons_list_2 <- weapons_joined %>% 
      {if(input$weapon_type_input_2 != "All") 
        filter(., type == input$weapon_type_input_2)
        else 
          filter(., !is.na(type))} %>%
      {if(input$weapon_material_input_2 != "All") 
        filter(., material == input$weapon_material_input_2)
        else 
          filter(., !is.na(type))}  %>% 
      {if(input$damage_type_input_2 != "All") 
        filter(., str_detect(damage_type, as.character(input$damage_type_input_2)))
        else 
          filter(., !is.na(type))} %>% 
      filter(!is.na(values)) %>% 
      distinct(item) %>% 
      pull() %>% 
      sort()
    
    updateSelectInput(session, inputId = "weapon_input_2", choices = weapons_list_2)
  })
  
  ### Reset filters -----------------
  observeEvent(input$reset_2, {
    updateSelectInput(session, inputId = "weapon_type_input_2", selected = "All")
    updateSelectInput(session, inputId = "weapon_material_input_2", selected = "All")
    updateSelectInput(session, inputId = "damage_type_input_2", selected = "All")
    
    weapons_list_2 <- weapons_joined %>% 
      distinct(item) %>% 
      pull() %>% 
      sort()
    
    updateSelectInput(session, inputId = "weapon_input_2", choices = weapons_list_2)
  })
  
  ### Copy filters ---------
  observeEvent(input$copy, {
    updateSelectInput(session, inputId = "weapon_type_input_2", selected = input$weapon_type_input)
    updateSelectInput(session, inputId = "weapon_material_input_2", selected = input$weapon_material_input)
    updateSelectInput(session, inputId = "damage_type_input_2", selected = input$damage_type_input)
    
    weapons_list_2 <- weapons_joined %>% 
      {if(input$weapon_type_input_2 != "All") 
        filter(., type == input$weapon_type_input_2)
        else 
          filter(., !is.na(type))} %>%
      {if(input$weapon_material_input_2 != "All") 
        filter(., material == input$weapon_material_input_2)
        else 
          filter(., !is.na(type))}  %>% 
      {if(input$damage_type_input_2 != "All") 
        filter(., str_detect(damage_type, as.character(input$damage_type_input_2)))
        else 
          filter(., !is.na(type))} %>% 
      filter(!is.na(values)) %>% 
      distinct(item) %>% 
      pull() %>% 
      sort()
    
    updateSelectInput(session, inputId = "weapon_input_2", choices = weapons_list_2)
  })
  
  
  ## Filter the weapon data based on weapon input ---------------
  filtered_weapons_2 <- reactive({
    weapons_crafting_clean %>% 
      filter(item == input$weapon_input_2)
  })
  
  ## Crafting Station Type - TEXT -----------
  output$crafting_station_output_2 <- renderText({
    filtered_weapons_2() %>% 
      filter(upgrade_level == input$item_level_input_2) %>% 
      distinct(crafting_station) %>% 
      pull() %>% 
      str_to_title()
  })
  
  ## Crafting Station Level - TEXT --------------
  output$crafting_station_level_output_2 <- renderText({
    level <- filtered_weapons_2() %>% 
      filter(upgrade_level == input$item_level_input_2) %>% 
      distinct(crafting_station_level) %>% 
      pull() %>% 
      str_to_title()
    
    paste("Level: ", level)
  })
  
  ## Update item level buttons depending on weapon selected --------------
  observeEvent(input$weapon_input_2, {
    choices <- filtered_weapons() %>% 
      distinct(upgrade_level) %>% 
      pull()
    updateRadioButtons(inputId = "item_level_input_2", choices = choices, inline = TRUE)
  })
  
  ## Table of materials and amounts -------------
  output$weapon_material_table_2 <- renderTable({
    filtered_weapons_2() %>% 
      filter(upgrade_level == input$item_level_input_2) %>% 
      mutate(amount_of_material = format(amount_of_material, nsmall = 0)) %>% 
      select(material, amount_of_material) %>% 
      rename("Material" = material, "Amount of Material" = amount_of_material)
    
  })
  
  ## PLOT of damage types ----------------
  output$weapon_stat_plot_2 <- renderPlotly({
    
    p <- weapons_data_clean %>% 
      filter(name == input$weapon_input_2,
             min_max != "max") %>% 
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
        y = "Damage Values (Min-Max)"
      ) 
    
    p <- p %>% style(
      #text = ~paste(damage_type, ": ", round(values, 0)),
      #hoverinfo = text,
      hovertemplate = "%{x}: %{y:.0f}<extra></extra>"
    )
    p <- p %>% layout(showlegend = FALSE)
    
    ggplotly(p)
  })
  
  # Food -----------------
  
  ## Change filter options ------------
  observeEvent(input$food_filter_input, {
    updateSelectInput(session, "filter_input", choices = food_filter_options[input$food_filter_input])
  })
  
  observeEvent(input$filter_input, {
    food_list <- food_stats %>% 
      {if (input$food_filter_input == "Ingredients")
        filter(., ingredients == input$filter_input)
        else
          filter(., !is.na(values))} %>% 
      {if (input$food_filter_input == "Biome")
        filter(., zone == input$filter_input)
        else
          filter(., !is.na(values))} %>% 
      {if (input$food_filter_input == "Main Stat")
        filter(., type == input$filter_input)
        else
          filter(., !is.na(values))}
  })
  

  
  ## plot of food stats ----------------
  output$food_stats_plot <- renderPlotly({
    p <- food_list %>% 
      ggplot(aes(reorder(recipe, score), values, fill = stat)) +
      geom_col(position = "dodge")
    
    ggplotly(p)
  })
  
}

