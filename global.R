library(tidyverse)
library(janitor)
library(bslib)
library(plotly)
library(here)

# FUNCTIONS --------------------
source(here("function_scripts/filter_weapons.R"))
source(here("function_scripts/plot_weapon_stats.R"))
source(here("function_scripts/plot_armor.R"))
source(here("function_scripts/filter_food.R"))
source(here("function_scripts/plot_food.R"))

# WEAPONS -------------
weapons_data_clean <- read_csv(here("clean_data/weapon_data.csv"))

weapon_types <- weapons_data_clean %>% 
  filter(type != "Upgrade") %>% 
  distinct(type) %>% 
  arrange(type) %>% 
  pull()

weapon_materials <- sort(unique(weapons_data_clean$material))

weapon_damage_types <- weapons_data_clean %>% 
  mutate(damage_type = str_extract(damage_type, "^[A-Z][a-z]+")) %>% 
  distinct(damage_type) %>% 
  pull() %>% 
  sort()

weapon_filter_options <- list(
  "Damage Type" = weapon_damage_types,
  "Material" = weapon_materials,
  "Weapon Type" = weapon_types
)

weapons_list <- sort(unique(weapons_data_clean$item)) 

# Armor -----------------------------------------------
armor <- read_csv(here("clean_data/armor_data.csv"))
#armor_crafting <- read_csv(here("clean_data/armor_crafting.csv"))


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


