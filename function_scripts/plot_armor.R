plot_armor <- function(armor_list, armor_type){
  p <- armor %>% 
  filter(item %in% armor_list) %>%
  filter(type == armor_type & upgrade_level == 1) %>%
  arrange(desc(armor)) %>% 
  head(5) %>% 
  select(item, armor, weight, speed, resistant, weak, materials) %>%
  mutate(across(where(is.character), ~ str_to_title(.x))) %>%
  pivot_longer(c(armor, weight), names_to = "stat", values_to = "value") %>% 
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