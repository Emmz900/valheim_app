library(tidyverse)
library(bslib)
library(plotly)
library(here)

weapons_crafting_clean <- read_csv(here("clean_data/weapons_crafting.csv"))
weapons_data_clean <- read_csv(here("clean_data/weapon_data.csv"))

weapons_crafting_small <- weapons_crafting_clean %>% 
  select(item, type, material) %>% 
  distinct()

weapons_data_small <- weapons_data_clean %>% 
  select(name, damage_type, values, min_max) %>% 
  distinct()

weapons_joined <- 
  full_join(weapons_crafting_small,
            weapons_data_small,
            by = join_by(item == name),
            relationship = "many-to-many") %>% 
  filter(!type %in% c("Upgrade", "Tool", "Shield", "Magic", "Weapon"))

weapons_list <- weapons_joined %>% 
  distinct(item) %>% 
  pull() %>% 
  sort()

weapon_type_list <- weapons_joined %>% 
  distinct(type) %>% 
  pull() %>% 
  append("All") %>% 
  sort()  

weapon_material_list <- weapons_joined %>% 
  distinct(material) %>% 
  pull() %>% 
  append("All") %>% 
  sort()

damage_type_list <- weapons_joined %>% 
  mutate(damage_type = str_extract(damage_type, "^[A-Z][a-z]+")) %>% 
  distinct(damage_type) %>% 
  pull() %>% 
  append("All") %>% 
  sort()