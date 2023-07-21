plot_food <- function(data){
  p <- data %>% 
    ggplot(aes(reorder(recipe, score), values, fill = stat, text = paste0(stat, ": ", values))) +
    geom_col(position = "dodge") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          text = element_text(size = 12)) +
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
      x = "Food Item",
      y = "Value",
      fill = "Stat"
    )
  
  #p <- p %>% layout(xaxis = list(tickangle = 315))
  
  ggplotly(p, tooltip = "text")
}