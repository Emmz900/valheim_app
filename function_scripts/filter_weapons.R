filter_weapons <- function(type_input, material_input, damage_input){
  weapons_joined %>% 
  {if(type_input != "All") # if weapon type input -> filter
    filter(., type == type_input)
    else
      filter(., !is.na(type))} %>%
  {if(material_input != "All") # if material input -> filter
    filter(., material == material_input)
    else
      filter(., !is.na(type))}  %>%
  {if(damage_input != "All") # if damage type input -> filter
    filter(., str_detect(damage_type, as.character(damage_input)))
    else
      filter(., !is.na(type))} %>%
  filter(!is.na(values)) %>%
  distinct(item) %>%
  pull() %>%
  sort()
}