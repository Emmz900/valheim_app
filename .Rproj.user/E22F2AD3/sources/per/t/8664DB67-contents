server <- function(input, output, session) {
  
  filtered_weapons <- reactive({
    weapons_crafting_clean %>% 
      filter(item == input$weapon_input)
  })
  
  output$crafting_station_output <- renderText({
    filtered_weapons() %>% 
      filter(upgrade_level == input$item_level_input) %>% 
      distinct(crafting_station) %>% 
      pull()
  })
  
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