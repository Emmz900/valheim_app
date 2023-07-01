library(tidyverse)

weapons_crafting_clean <- read_csv("sorted_data/weapons_crafting")
weapons_data_clean <- read_csv("sorted_data/weapon_data")

weapons_crafting_small <- weapons_crafting_clean %>% 
  select(item, type, material) %>% 
  distinct()

weapons_data_small <- weapons_data_clean %>% 
  select(name) %>% 
  distinct()

weapons_joined <- 
  full_join(weapons_crafting_small,
            weapons_data_small,
            by = join_by(item == name)) %>% 
  filter(!type %in% c("upgrade", "tool", "shield", "magic", "weapon"))

weapons_list <- weapons_joined %>% 
  distinct(item) %>% 
  pull() %>% 
  sort()

weapon_type_list <- weapons_joined %>% 
  #filter(!type %in% c("upgrade", "tool", "shield", "magic", "weapon")) %>% 
  distinct(type) %>% 
  pull() %>% 
  append("All") %>% 
  sort()  

weapon_material_list <- weapons_joined %>% 
  distinct(material) %>% 
  pull() %>% 
  append("All") %>% 
  sort()

