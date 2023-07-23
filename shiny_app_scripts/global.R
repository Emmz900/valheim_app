library(tidyverse)
library(janitor)
library(bslib)
library(plotly)
library(here)

# FUNCTIONS --------------------
source(here("function_scripts/filter_weapons.R"))
source(here("function_scripts/plot_weapon_stats.R"))
source(here("function_scripts/filter_food.R"))
source(here("function_scripts/plot_food.R"))

# WEAPONS -------------
weapons_crafting_clean <- read_csv(here("clean_data/weapons_crafting.csv"))
weapons_data_clean <- read_csv(here("clean_data/weapon_data.csv"))

weapons_crafting_small <- weapons_crafting_clean %>% 
  select(item, type, material) %>% 
  distinct()

weapons_data_small <- weapons_data_clean %>% 
  select(name, damage_type, values, min_max) %>% 
  distinct()

## Join ---------
weapons_joined <- 
  full_join(weapons_crafting_small,
            weapons_data_small,
            by = join_by(item == name),
            relationship = "many-to-many") %>% 
  filter(!type %in% c("Upgrade", "Tool", "Shield", "Magic", "Weapon"))

weapon_type_1 <- sort(unique(weapons_joined$type))
weapon_material_1 <- sort(unique(weapons_joined$material))
weapon_damage_1 <- weapons_joined %>% 
  mutate(damage_type = str_extract(damage_type, "^[A-Z][a-z]+")) %>% 
  distinct(damage_type) %>% 
  pull() %>% 
  sort()
weapon_filter_options_1 <- list(
  "Damage Type" = weapon_damage_1,
  "Material" = weapon_material_1,
  "Weapon Type" = weapon_type_1
)

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

weapon_filter_options <- list(
  "Damage Type" = damage_type_list,
  "Material" = weapon_material_list,
  "Weapon Type" = weapon_type_list
)

# FOOD -------------
food_ingredients <- clean_names(read_csv(here("raw_data/food_ingredients.csv")))
food_stats <- clean_names(read_csv(here("raw_data/food_stats.csv"))) %>% 
  mutate(zone = factor(str_to_title(zone),
                       levels = c("Meadows", "Black Forest", "Swamp", "Ocean",
                                  "Mountains", "Plains", "Mistlands")),
         type = str_to_title(type)) %>% 
  pivot_longer(health:duration, names_to = "stat", values_to = "values")

## Join -----------
all_food <- food_stats %>% 
  full_join(food_ingredients, by = "recipe", relationship = "many-to-many") %>% 
  mutate(oven = coalesce(oven, "n")) %>% 
  mutate(across(where(is.character), str_to_title))
         

## Food Filter Options ------------
food_filter_options <- list(
  "Ingredients" = sort(unique(all_food$ingredients)),
  "Biome" = unique(all_food$zone),
  "Main Stat" = unique(all_food$type)
)

food_type_list <- unique(all_food$type) 

food_recipe_list <- all_food %>% 
  filter(type == "Health") %>% 
  distinct(recipe) %>% 
  pull()


