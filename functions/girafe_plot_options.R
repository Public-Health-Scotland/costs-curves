#' girafe_plot_options
#'
#' Takes a ggplot obeject and adds interactive tooltips and hover/selection options
#'
#' @param gg_plot_obj 
#'
#' @returns
#' @export
#'
#' @examples
girafe_plot_options <- function(gg_plot_obj){
  # CSS options - separate hover and selection styles
  hover_css <- "
  filter: brightness(75%);
  cursor: pointer;
  transition: all 0.5s ease-out;
  stroke-width: 1.5px;
  fill-opacity: 0.8;
"
  
  selection_css <- "
  filter: brightness(75%);
  cursor: pointer;
  transition: all 0.5s ease-out;
  filter: brightness(1.15);
  r: 2px;
  stroke-width: 1.5px 
"
  
  inv_css <- "opacity:0.5; transition: all 0.2s ease-out;"
  
  # Add interactive tooltips with proper selection
  girafe(ggobj = gg_plot_obj, options = list(
    opts_hover(css = hover_css),
    opts_tooltip(css = "background-color:lightgray; color:black; border-radius:10px;"),
    opts_selection(
      css = selection_css,
      only_shiny = FALSE, # needed for selection to work in Quarto
      type = "single", 
      linked = TRUE
    ),
    opts_selection_inv(css = inv_css)
  ))
}