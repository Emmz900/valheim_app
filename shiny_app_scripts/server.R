server <- function(input, output, session) {
  
  # All Weapons ----------------------
  ## Filter list  ------------------
  observeEvent(input$weapon_filter_options_input, {
    choices <- weapon_filter_options_1[[input$weapon_filter_options_input]][-1]
    updateSelectInput(session, "weapon_filter_input",
                      choices = choices) #REMOVE "ALL"
  })
  
  ## Filter Weapons -----------------
  weapon_filtered_list <- reactive({
    weapons_joined %>% 
      #browser()
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
    updateRadioButtons(session, "weapon_choice_all_input",
                       choices = weapon_filtered_list(), inline = TRUE)
  })
  
  ## Plot All Weapons --------------
  output$all_weapons_plot <- renderPlotly({
    p <- weapons_data_clean %>% 
      filter(name %in% weapon_filtered_list(),
             min_max == "max", # currently shows multiple, limit to only one
             !is.na(values)) %>% 
      ggplot(aes(name, values, fill = damage_type, text = paste0(damage_type, ": ", values))) +
      geom_col(position = "dodge") +
      # scale_fill_manual(values = c(
      #   "diff" = "green4",
      #   "min" = "green3"
      # )) +
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
    
    # p <- p %>% style(
    #   #text = ~paste(damage_type, ": ", round(values, 0)),
    #   #hoverinfo = text,
    #   hovertemplate = "%{fill}: %{y:.0f}<extra></extra>"
    # )
    
    ggplotly(p, tooltip = "text")
  })
  
  ## Crafting Station Type - TEXT -----------
  output$crafting_station_output_1 <- renderText({
    weapons_crafting_clean %>%
      filter(item == input$weapon_choice_all_input) %>% 
      filter(upgrade_level == input$item_level_input_1) %>% 
      distinct(crafting_station) %>% 
      pull() %>% 
      str_to_title()
  })
  
  ## Crafting Station Level - TEXT --------------
  output$crafting_station_level_output_1 <- renderText({
    level <- weapons_crafting_clean %>%
      filter(item == input$weapon_choice_all_input) %>% 
      filter(upgrade_level == input$item_level_input_1) %>% 
      distinct(crafting_station_level) %>% 
      pull() %>% 
      str_to_title()
    
    paste("Level: ", level)
  })
  
  ## Update item level buttons depending on weapon selected --------------
  observeEvent(input$weapon_choice_all_input, {
    choices <- weapons_crafting_clean %>%
      filter(item == input$weapon_choice_all_input) %>% 
      distinct(upgrade_level) %>% 
      pull()
    updateRadioButtons(inputId = "item_level_input_1", choices = choices,
                       inline = TRUE)
  })
  
  
  ## Table of materials and amounts -------------
  output$weapon_material_table_1 <- renderTable({
    weapons_crafting_clean %>%
      filter(item == input$weapon_choice_all_input) %>% 
      filter(upgrade_level == input$item_level_input_1) %>% 
      mutate(amount_of_material = format(amount_of_material, nsmall = 0)) %>% 
      select(material, amount_of_material) %>% 
      rename("Material" = material, "Amount of Material" = amount_of_material)
    
  })
  
  # Weapon 1 ----------------------
  ## Filter weapons list on button press ----------
  observeEvent(input$update, {
    weapons_list <- filter_weapons(input$weapon_type_input,
                                   input$weapon_material_input,
                                   input$damage_type_input)
    
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
  output$weapon_stat_plot <- renderPlotly({
    plot_weapon_stats(input$weapon_input)
  })
  
  # Weapon 2 ----------
  ## If weapon type input is changed, update weapon list ------
  observeEvent(input$update_2, {
    weapons_list_2 <- filter_weapons(input$weapon_type_input_2,
                                     input$weapon_material_input_2,
                                     input$damage_type_input_2)
    
    updateSelectInput(session, inputId = "weapon_input_2",
                      choices = weapons_list_2)
  })
  
  ### Reset filters -----------------
  observeEvent(input$reset_2, {
    updateSelectInput(session, inputId = "weapon_type_input_2",
                      selected = "All")
    updateSelectInput(session, inputId = "weapon_material_input_2",
                      selected = "All")
    updateSelectInput(session, inputId = "damage_type_input_2",
                      selected = "All")
    
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
    
    weapons_list_2 <- filter_weapons(input$weapon_type_input_2,
                                     input$weapon_material_input_2,
                                     input$damage_type_input_2)
    
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
    plot_weapon_stats(input$weapon_input_2)
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
      arrange(score) %>% 
      distinct(recipe) %>% 
      pull()
    
    updateRadioButtons(session, "food_item_input",
                       choices = choices, inline = TRUE)
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
  output$food_crafting_station_outputs <- renderTable({
    cooking_stations <- tibble(
      "Cooking Stations" = c(
        if(unique(food_item()$oven) == "N"){
        } else {
          "Oven"
        },
        
        if(is.na(unique(food_item()$cauldron_level))){
        } else {
          (paste("Cauldron Level", unique(food_item()$cauldron_level)))
        }
      )   
    )
    
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

