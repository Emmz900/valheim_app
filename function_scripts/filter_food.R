filter_food <- function(options_input, filter_input){
  all_food %>% 
    {if (options_input == "Ingredients")
      filter(., ingredients == filter_input)
      else
        filter(., !is.na(values))} %>% 
    {if (options_input == "Biome")
      filter(., zone == filter_input)
      else
        filter(., !is.na(values))} %>% 
    {if (options_input == "Main Stat")
      filter(., type == filter_input)
      else
        filter(., !is.na(values))}
}