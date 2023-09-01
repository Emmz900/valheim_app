library(tidyverse)
library(janitor)

armor <- clean_names(read_xlsx("raw_data/armour.xlsx"))
sets <- clean_names(read_xlsx("raw_data/armour.xlsx", sheet = 2))
all_items <- clean_names(read_xlsx("raw_data/all_crafting.xlsx"))

# Find object types -----------
types <- all_items %>% 
  select(item, type) %>% 
  filter(type != "upgrade") %>% 
  distinct()

# Label armour as head/chest/cape/legs ---------
armor_type <- armor %>% 
  left_join(types, relationship = "many-to-many") %>% 
  left_join(sets, relationship = "many-to-many") %>% 
  clean_names() %>% 
  mutate(across(where(is.character), ~ str_to_lower(.x)))

# Collapse materials ---------
crafting_armor <- all_items %>% 
  semi_join(armor_type, join_by(item)) %>% 
  mutate(across(where(is.character), ~ str_to_lower(.x))) %>% 
  pivot_wider(names_from = crafting_station, values_from = crafting_station_level) %>% 
  clean_names() %>% 
  group_by(item, upgrade_level) %>% 
  summarise(materials = toString(unique(material)))

# Join data sets ------------
joined_armor <- armor_type %>% 
  left_join(crafting_armor, by = c("item", "upgrade_level"))

write_csv(joined_armor, "clean_data/armor_data.csv")
