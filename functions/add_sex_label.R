add_sex_label <- function(.){
  . |> mutate(sex_label = ifelse(sex == 1, "Male", "Female"))
}
