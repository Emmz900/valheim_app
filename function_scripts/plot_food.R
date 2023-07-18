plot_food <- function(data){
  p <- data %>% 
    ggplot(aes(reorder(recipe, score), values, fill = stat, text = paste0(stat, ": ", values))) +
    geom_col(position = "dodge") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          text = element_text(size = 12)) +
    theme_classic() +
    labs(
      x = "Food Item",
      y = "Value",
      fill = "Stat"
    )
  
  ggplotly(p, tooltip = "text")
}