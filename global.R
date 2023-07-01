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
            by = join_by(item == name))

weapons_list <- weapons_joined %>% 
  mutate(item = str_to_title(item)) %>% 
  distinct(item) %>% 
  pull()

weapon_type_list <- weapons_joined %>% 
  filter(!type %in% c("upgrade", "tool", "shield", "magic", "weapon")) %>% 
  mutate(type = str_to_title(type)) %>% 
  distinct(type) %>% 
  pull() %>% 
  append("All") %>% 
  sort()  

weapon_material_list <- weapons_joined %>% 
  mutate(material = str_to_title(material)) %>% 
  distinct(material) %>% 
  pull() %>% 
  append("All") %>% 
  sort()

