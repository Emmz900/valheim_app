library(tidyverse)
library(janitor)

armor <- clean_names(read_xlsx("raw_data/armour.xlsx"))
sets <- clean_names(read_xlsx("raw_data/armour.xlsx", sheet = 2))
all_items <- clean_names(read_xlsx("raw_data/all_crafting.xlsx"))

## Find object types
types <- all_items %>% 
  select(item, type) %>% 
  filter(type != "upgrade") %>% 
  distinct()

## label armour as head/chest/cape/legs
armor_type <- armor %>% 
  left_join(types, relationship = "many-to-many") %>% 
  left_join(sets, relationship = "many-to-many") #%>% 
  #mutate(across(where(is.character), ~ str_to_title(.x)))

# armor_type <- armor_type %>% 
#   clean_names(case = "title")

write_csv(armor_type, "clean_data/armor_data.csv")

armor_clean <- armor %>% 
  clean_names() %>% 
  mutate(across(where(is.character), ~ str_to_lower(.x)))

crafting_armor <- all_items %>% 
  semi_join(armor_clean, join_by(item)) %>% 
  mutate(across(where(is.character), ~ str_to_lower(.x))) %>% 
  pivot_wider(names_from = crafting_station, values_from = crafting_station_level) %>% 
  clean_names()
  
write_csv(crafting_armor, "clean_data/armor_crafting.csv")