plot_armor <- function(armor_data, armor_type, armor_list){
  p <- armor_data %>% 
    filter(item %in% armor_list) %>%
    group_by(item) %>% 
    filter(upgrade_level == max(upgrade_level)) %>% 
    arrange(desc(armor)) %>% 
    head(5) %>% 
    select(item, upgrade_level, armor, weight) %>%
    pivot_longer(c(armor, weight), names_to = "stat", values_to = "value") %>% 
    mutate(item = str_to_title(item),
           stat = str_to_title(stat)) %>%
    unite("item", item:upgrade_level, sep = " - Level ",  remove = TRUE) %>% 
    ggplot(aes(item, value, fill = stat)) +
    geom_col(position = "dodge") +
    theme_classic() +
    theme(text = element_text(colour = "white"),
          axis.text = element_text(colour = "white"),
          legend.background = element_rect(fill = "transparent"),
          panel.background = element_rect(fill = "transparent"),
          panel.border = element_rect(fill = "transparent",
                                      colour = "transparent"),
          plot.background = element_rect(fill = "transparent",
                                         colour = NA),
          axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(
      x = armor_type,
      y = "Stat",
      fill = ""
    ) 
  ggplotly(p)
}