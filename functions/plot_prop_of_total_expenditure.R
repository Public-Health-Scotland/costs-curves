plot_prop_of_total_expenditure <- function(x, x_title){
  x_axis_labels <- x |> 
    arrange(agegrp) |> 
    select(agegrp, agegrp_label) |> 
    distinct() |> 
    pull(agegrp_label)
  
  point_shapes_vec <- c(3,4,8, 15:17, 23)
  
  ggplot(x, aes(x = agegrp, y = prop_of_total_exp, color = staff_type_label, 
                group = staff_type_label, data_id = staff_type_label))+
    geom_point_interactive(size = 1.5, 
                         aes(
                           shape = staff_type_label,
                           tooltip = paste0(
                           "Staff Type: ", staff_type_label,
                           "\nAge: ", agegrp_label,
                           "\nProportion: ", percent(prop_of_total_exp, accuracy = 0.1)
                           )
                         ),
                         hover_nearest = TRUE
    )+
    scale_shape_manual(values = point_shapes_vec)+
    geom_line_interactive()+
    
    
    # labels, colors, themes
    scale_x_continuous(breaks = c(1:length(x_axis_labels)), labels = x_axis_labels)+
    labs(title = x_title, x = "Age Group", y = "Proportion of Cost per Head", 
         color = "Staff Type", shape = "Staff Type")+
    scale_color_manual_interactive(values = viridis(n = 7))+
    theme_minimal()+
    theme(axis.text.x = element_text(size = 8, angle = 45), 
          plot.title = element_text(size = 10), 
          plot.subtitle = element_text(size = 8)) 
  # ggplot(x, aes(x = agegrp, y = prop_of_total_exp, fill = staff_type_label))+
  #   geom_bar_interactive(position="stack", stat="identity", 
  #                        aes(tooltip = paste0(
  #                          "Staff Type: ", staff_type_label,
  #                          "\nAge: ", agegrp_label,
  #                          "\nProportion: ", prop_of_total_exp)
  #                        ),
  #                        hover_nearest = TRUE
  #   )+
  #   
  #   # labels, colors, themes
  #   scale_x_continuous(breaks = c(1:length(x_axis_labels)), labels = x_axis_labels)+
  #   labs(title = x_title, x = "Age Group", y = "Proportion of Cost per Head", 
  #        fill = "Staff Type")+
  #   scale_fill_manual_interactive(values = viridis(n = 6))+
  #   theme_minimal()+
  #   theme(axis.text.x = element_text(size = 8, angle = 45), 
  #         plot.title = element_text(size = 10), 
  #         plot.subtitle = element_text(size = 8)) 
}