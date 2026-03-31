#' plot_total_vs_workforce
#' 
#' custom ggplot function to plot cost per head by age and sex
#'
#' @param x dataframe of cost per head data, must have the variables: `agegrp`,
#'  `agegrp_label`, `acute_cph`, and `costs_type`
#' @param x_title title of plot
#'
#' @returns a line chart of the cost per head age and sex
#' @export
#'
#' @examples
plot_total_vs_workforce <- function(x, x_title){
  
  x_axis_labels <- x |> 
    arrange(agegrp) |> 
    select(agegrp, agegrp_label) |> 
    distinct() |> 
    pull(agegrp_label)
  
  p <- ggplot(x,
         aes(x = agegrp, y = acute_cph, color = costs_type,
             group = costs_type, data_id = costs_type))+
    
    # plot points and lines
    geom_point_interactive(size = 1.5,
                           aes(
                             shape = costs_type,
                             tooltip = paste0(
                               "Costs Category: ", costs_type,
                               "\nAge: ", agegrp_label,
                               "\nCPH: ", acute_cph)
                             )
                           )+
    geom_line_interactive()+
    
    # scale the Y axis to log base 10 
    scale_y_log10() +
    
    # labels, colors, themes
    scale_x_continuous(breaks = c(1:length(x_axis_labels)), labels = x_axis_labels)+
    labs(title = x_title, x = "Age Group", y = "log_10(Cost per Head)", 
         subtitle = "Cost per head figures are plotted on a log base 10 scale", 
         color = "Costs Category", shape = "Costs Category")+
    scale_color_manual_interactive(values = viridis(begin = 0.25, end = 0.75, n = 2, option = "magma"))+
    theme_minimal()+
    theme(axis.text.x = element_text(size = 6, angle = 45), 
          plot.title = element_text(size = 10), 
          plot.subtitle = element_text(size = 8)) 
  
  return(p)
}