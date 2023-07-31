library(tidyverse)
library(readxl)

crafting_data <- read_xlsx("raw_data/crafting.xlsx")
weapon_data <- read_xlsx("raw_data/crafting.xlsx", sheet = 2)

# Weapon crafting data -----------
#View(crafting_data)
crafting_data_clean <- janitor::clean_names(crafting_data) %>% 
  mutate(across(where(is.character), str_to_title)) %>% 
  mutate(upgrade_level = coalesce(upgrade_level, 1))
#write_csv(crafting_data_clean, "clean_data/weapons_crafting.csv")

# Weapon damage data -----------
#View(weapon_data)
weapon_data_split <- weapon_data %>% 
  janitor::clean_names() %>% 
  select(-dps, -stamina) %>% 
  mutate(
    type = str_to_title(str_remove(type, "s$")), # remove plurals
    damage_type = str_to_title(str_extract(damage, "[A-Z][a-z]+")), # Extract damage type from damage column
    damage = str_extract(damage, "[\\.0-9/]+"), # Extract damage values
    backstab = as.numeric(str_remove(backstab, "x")), # Remove x from backstab and convert to numeric
  ) %>% 
  mutate(
    # Rename total damage column
    TOTAL = max_damage,
    
    min_damage = as.numeric(str_extract(damage, "[0-9]+")),
    max_damage = as.numeric(str_extract(damage, "[0-9\\.]+$")),
    
    # rename damage and dps types
    damage_type_max = paste0(damage_type, "_max"),
    damage_type_min = paste0(damage_type, "_min"),
    damage_type_diff = paste0(damage_type, "_diff"),
    
    "backstab x10" = backstab * 10, #increase backstab for readability on plot
    
    type = case_when(
      type == "Knive" ~ "Knife",
      type == "2-Handed Clubs" ~ "Club",
      type == "Two-Handed Axe" ~ "Axe",
      .default = type
    )
  ) %>% 
  
  # add columns for the difference between min and max
  mutate(
         diff_damage = max_damage - min_damage
         ) %>% 

  select(-damage, -total_damage, -damage_type, -backstab)  

weapon_data_long <- weapon_data_split %>% 
  # make damage type columns before pivoting all damage indicators into two columns
  pivot_wider(names_from = damage_type_max, values_from = max_damage) %>% 
  pivot_wider(names_from = damage_type_min, values_from = min_damage) %>% 
  pivot_wider(names_from = damage_type_diff, values_from = diff_damage) %>% 

  pivot_longer(-c(name,type), names_to = "damage_type", values_to = "values") %>% 
  
  mutate(across(where(is.character), str_to_title)) %>% 
  distinct() %>% 
  
  # Add min_max column and simplify damage type column
  mutate(min_max = #
           case_when(
             str_detect(damage_type, "_min") ~ "min",
             str_detect(damage_type, "_max") ~ "max",
             str_detect(damage_type, "_diff") ~ "diff"
           ),
         damage_type = str_remove(damage_type, "_min|_max|_diff")
  ) %>% 
  mutate(min_max = coalesce(min_max, "max")) %>% 
  filter(damage_type != "Na") %>% 
  rename(item = name)

#write_csv(weapon_data_long, "clean_data/weapon_data.csv")

# Join both data sets for weapon info
weapons_joined <- weapon_data_long %>% 
  select(-type) %>% 
  full_join(crafting_data_clean,
            by = join_by(item),
            relationship = "many-to-many") %>% 
  filter(!type %in% c("Tool", "Shield", "Magic", "Weapon"))

write_csv(weapons_joined, "clean_data/weapon_data.csv")

