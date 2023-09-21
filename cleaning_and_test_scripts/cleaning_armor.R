library(tidyverse)
library(readxl)
library(janitor)

armor <- clean_names(read_xlsx("raw_data/armour.xlsx"))
sets <- clean_names(read_xlsx("raw_data/armour.xlsx", sheet = 2))
all_items <- clean_names(read_xlsx("raw_data/all_crafting.xlsx"))

joined_armor <- all_items %>% 
  mutate(across(where(is.character), ~ str_to_lower(.x))) %>% 
  select(-c(description, set_bonus)) %>% 
  right_join(armor, by = join_by(item, upgrade_level)) %>% 
  left_join(sets) %>% 
  group_by(item, type, crafting_station_level, crafting_station, upgrade_level,
           armor, resistant, weak, set, weight, speed, other, bonus) %>% 
  summarise(materials = toString(unique(material)),
            material_amounts = toString(amount_of_material)) %>% 
  pivot_wider(names_from = crafting_station, values_from = crafting_station_level) %>% 
  clean_names()

write_csv(joined_armor, "clean_data/armor_data.csv")
