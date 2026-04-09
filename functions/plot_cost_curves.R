#' plot_cost_curves
#' 
#' custom ggplot function to plot cost per head by age and sex
#'
#' @param x dataframe of cost per head data, must have the variables: `agegrp`,
#'  `agegrp_label`, `sex_label`, `sex`, `acute_cph`
#' @param x_title title of plot
#'
#' @returns a line chart of the cost per head age and sex
#' @export
#'
#' @examples
plot_cost_curves <- function(x, x_title){
  
  x_axis_labels <- x |> 
    arrange(agegrp) |> 
    select(agegrp, agegrp_label) |> 
    distinct() |> 
    pull(agegrp_label)
  
  p <- ggplot(x,
         aes(x = agegrp, y = acute_cph, color = sex_label,
             group = sex_label, data_id = sex_label))+
    
    # plot points and lines
    geom_point_interactive(size = 1.5,
                           aes(
                             shape = sex_label,
                             tooltip = paste0(
                               "Sex: ", sex_label,
                               "\nAge: ", agegrp_label,
                               "\nCPH: ", acute_cph)
                             ), 
                           hover_nearest = TRUE
                           )+
    geom_line_interactive()+
    
    # labels, colors, themes
    scale_x_continuous(breaks = c(1:length(x_axis_labels)), labels = x_axis_labels)+
    labs(title = x_title, x = "Age Group", y = "Cost per Head", 
         color = "Sex", shape = "Sex")+
    scale_color_manual_interactive(values = viridis(begin = 0.25, end = 0.75, n = 2))+
    theme_minimal()+
    theme(axis.text.x = element_text(size = 6, angle = 45), 
          plot.title = element_text(size = 10)) 
  
  return(p)
}