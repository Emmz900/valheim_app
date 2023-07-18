plot_weapon_stats <- function(weapon_input){
  p <- weapons_data_clean %>% 
    filter(name == weapon_input,
           min_max != "max") %>% 
    ggplot(aes(damage_type, values, fill = min_max)) +
    geom_col(show.legend = FALSE) +
    scale_fill_manual(values = c(
      "diff" = "green4",
      "min" = "green3"
    )) +
    scale_y_continuous(breaks = seq(0, 220, 20), limits = c(0, 220)) +
    theme_classic() +
    labs(
      x = "Damage Type",
      y = "Damage Values (Min-Max)"
    ) 
  
  p <- p %>% style(
    #text = ~paste(damage_type, ": ", round(values, 0)),
    #hoverinfo = text,
    hovertemplate = "%{x}: %{y:.0f}<extra></extra>"
  )
  p <- p %>% layout(showlegend = FALSE)
  
  ggplotly(p)
}