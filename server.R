server <- function(input, output, session) {
  
  # All Weapons ----------------------
  ## Filter list  ------------------
  observeEvent(input$weapon_filter_options_input, {
    choices <- weapon_filter_options[[input$weapon_filter_options_input]][-1]
    updateSelectInput(session, "weapon_filter_input",
                      choices = choices) 
  })
  
  ## Filter Weapons -----------------
  weapon_filtered_list <- reactive({
    weapons_data_clean %>% 
      {if (input$weapon_filter_options_input == "Damage Type")
        filter(.,
               str_detect(damage_type,
                          as.character(input$weapon_filter_input))) 
        else
          filter(., !is.na(values))} %>% 
      {if (input$weapon_filter_options_input == "Material")
        filter(., material == input$weapon_filter_input)
        else
          filter(., !is.na(values))} %>% 
      {if (input$weapon_filter_options_input == "Weapon Type")
        filter(., type == input$weapon_filter_input)
        else
          filter(., !is.na(values))} %>%  
      arrange(desc(values))%>%
      distinct(item) %>% 
      head(10) %>% 
      pull()
  })
  
  ## Update weapon selection ------------
  observeEvent(input$weapon_filter_input, {
    updateSelectInput(session, "weapon_choice_all_input",
                      choices = weapon_filtered_list())
  })
  
  ## Plot All Weapons --------------
  output$all_weapons_plot <- renderPlotly({
    p <- weapons_data_clean %>% 
      select(item:min_max) %>% 
      distinct() %>% 
      filter(item %in% weapon_filtered_list(),
             min_max == "max",
             !is.na(values)) %>% 
      ggplot(aes(item, values, fill = damage_type, text = paste0(damage_type, ": ", values))) +
      geom_col(position = "dodge") +
      scale_y_continuous(breaks = seq(0, 220, 20),
                         limits = c(0, 220)) +
      theme_classic() +
      theme(text = element_text(colour = "white"),
            axis.text = element_text(colour = "white"),
            legend.background = element_rect(fill = "transparent"),
            panel.background = element_rect(fill = "transparent"),
            panel.border = element_rect(fill = "transparent",
                                        colour = "transparent"),
            plot.background = element_rect(fill = "transparent",
                                           colour = NA)) +
      labs(
        x = "Weapon",
        y = "Damage Values",
        fill = "Damage Type"
      ) 
    
    ggplotly(p, tooltip = "text")
  })
  
  ## Crafting Station Type - TEXT -----------
  output$crafting_station_output_1 <- renderText({
    weapons_data_clean %>%
      filter(item == input$weapon_choice_all_input) %>% 
      filter(upgrade_level == input$item_level_input_1) %>% 
      distinct(crafting_station) %>% 
      pull() %>% 
      str_to_title()
  })
  
  ## Crafting Station Level - TEXT --------------
  output$crafting_station_level_output_1 <- renderText({
    level <- weapons_data_clean %>%
      filter(item == input$weapon_choice_all_input) %>% 
      filter(upgrade_level == input$item_level_input_1) %>% 
      distinct(crafting_station_level) %>% 
      pull() %>% 
      str_to_title()
    
    paste("Level: ", level)
  })
  
  ## Update item level buttons depending on weapon selected --------------
  observeEvent(input$weapon_choice_all_input, {
    choices <- weapons_data_clean %>%
      filter(item == input$weapon_choice_all_input) %>% 
      distinct(upgrade_level) %>% 
      pull()
    updateRadioButtons(inputId = "item_level_input_1", choices = choices,
                       inline = TRUE)
  })
  
  ## Table of materials and amounts -------------
  output$weapon_material_table_1 <- renderTable({
    weapons_data_clean %>%
      filter(item == input$weapon_choice_all_input) %>% 
      filter(upgrade_level == input$item_level_input_1) %>% 
      mutate(amount_of_material = format(amount_of_material, nsmall = 0)) %>% 
      select(material, amount_of_material) %>% 
      distinct() %>%
      rename("Material" = material, "Amount of Material" = amount_of_material)
    
  })
  
  # Armor ----------------
  ## Armor list -----------
  armor_filtered <- reactive({
    armor %>% 
      filter(is.na(workbench) | workbench <= input$workbench_input) %>% 
      filter(is.na(forge) | forge <= input$forge_input) %>%
      filter(is.na(galdr_table) | galdr_table <= input$galdr_input) %>%
      filter(is.na(black_forge) | black_forge <= input$black_forge_input)
  })
  
  armor_list <- reactive({
    armor_filtered() %>% 
      distinct(item) %>% 
      pull()
  })
  
  observeEvent(input$armor_refresh, {
    ## Chest ----------
    output$chest_table <- renderPlotly({
      plot_armor(armor_filtered(), "chest", chest_list)
    })
    
    chest_list <- armor_filtered() %>% 
      filter(type == "chest") %>% 
      distinct(item) %>% 
      pull()
    
    updateSelectInput(inputId = "chest_input", choices = chest_list)
    
    ## Legs -----------------
    output$legs_table <- renderPlotly({
      plot_armor(armor_filtered(), "legs", legs_list)
    })
    
    legs_list <- armor %>% 
      filter(item %in% armor_list() & type == "legs") %>% 
      distinct(item) %>% 
      pull()
    updateSelectInput(inputId = "legs_input", choices = legs_list)
    
    ## Helmet ------
    output$helmet_table <- renderPlotly({
      plot_armor(armor_filtered(), "helmet", helmet_list)
    })
    
    helmet_list <- armor %>% 
      filter(item %in% armor_list() & type == "helmet") %>% 
      distinct(item) %>% 
      pull()
    updateSelectInput(inputId = "helmet_input", choices = helmet_list)
    
    ## Cape ---------
    output$cape_table <- renderPlotly({
      plot_armor(armor_filtered(), "cape", cape_list)
    })
    
    cape_list <- armor %>% 
      filter(item %in% armor_list() & type == "cape") %>% 
      distinct(item) %>% 
      pull()
    updateSelectInput(inputId = "cape_input", choices = cape_list)
    
  })
  
  output$total_armor <- renderTable({
    armor_filtered() %>% 
      filter(item == input$chest_input | item == input$legs_input |
               item == input$helmet_input | item == input$cape_input) %>%
      group_by(item) %>% 
      filter(upgrade_level == max(upgrade_level)) %>% 
      ungroup() %>% 
      select(item, upgrade_level, armor, weight, speed, resistant, weak, set) %>% 
      mutate(speed = coalesce(speed, 0)) %>% 
      mutate(speed = speed * 100) %>% 
      bind_rows(summarise(., across(where(is.numeric), sum),
                          across(where(is.character), ~""))
      ) %>% 
      mutate(across(where(is.character), str_to_title)) %>% 
      mutate(item = case_when(item == "" ~ "Total",
                              .default = item)) %>% 
      rename_all(stringr::str_to_title)
  })
    
  
  # Food -----------------
  
  ## Change filter options ------------
  observeEvent(input$food_filter_options_input, {
    updateSelectInput(session, "food_filter_input",
                      choices = food_filter_options[input$food_filter_options_input])
  })
  
  ## Filter data based on food filters --------------
  food_list <- reactive({
    filter_food(input$food_filter_options_input, input$food_filter_input)
  })
  
  ## Change recipe options ----------------------
  observeEvent(input$food_filter_input, {
    choices <- food_list() %>% 
      filter(oven == "Y" | !is.na(cauldron_level)) %>% 
      arrange(score) %>% 
      distinct(recipe) %>% 
      pull()
    
    updateSelectInput(session, "food_item_input",
                      choices = choices)
  })
  
  ## Plot of food stats ----------------
  output$food_stats_plot <- renderPlotly({
    plot_food(food_list())
  })
  
  ## Filter table for food item --------------
  food_item <- reactive({
    all_food %>%
      filter(recipe == input$food_item_input)
  })
  
  ## Crafting Station and Cauldron level ---------------
  output$food_crafting_station_outputs <- renderText({
    if(unique(food_item()$oven) == "N"){
    } else {
      "Oven Needed"
    }
  })
  
  output$food_crafting_station_level <- renderText({      
    if(is.na(unique(food_item()$cauldron_level))){
    } else {
      (paste("Cauldron Level: ", unique(food_item()$cauldron_level)))
    }
  })
  
  ## Food stats table -----------------
  output$food_stats_table <- renderTable({
    food_item() %>% 
      mutate(Values = format(values, nsmall = 0)) %>% 
      select(stat, Values) %>% 
      rename("Stat" = stat) %>% 
      distinct()
  })
  
  ## Food crafting and ingredients table ------------------
  output$food_crafting_table <- renderTable({
    if(is.na(food_item()$ingredients[1])){
    } else {
      food_item() %>%
        mutate(amount_of_ingredient = format(amount_of_ingredient, nsmall = 0)) %>% 
        select(ingredients, amount_of_ingredient) %>% 
        rename("Ingredients" = ingredients) %>% 
        rename("Quantity" = amount_of_ingredient) %>% 
        distinct()
    }
  })
}

