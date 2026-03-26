#' add_age_labels
#'
#' add human labels to the age groups.
#'
#' @param . dataframe with an `agegrp` column
#'
#' @returns dataframe with an `agegrp_label` column
#' @export
#'
#' @examples
add_age_labels <- function(.){
  . |> 
    mutate(agegrp_label = case_when(
      agegrp == 1 ~ "0-1",
      agegrp == 2 ~ "2-4",
      agegrp == 3 ~ "5-9",
      agegrp == 4 ~ "10-14",
      agegrp == 5 ~ "15-19",
      agegrp == 6 ~ "20-24",
      agegrp == 7 ~ "25-29",
      agegrp == 8 ~ "30-34",
      agegrp == 9 ~ "35-39",
      agegrp == 10 ~ "40-44",
      agegrp == 11 ~ "45-49",
      agegrp == 12 ~ "50-54",
      agegrp == 13 ~ "55-59",
      agegrp == 14 ~ "60-64",
      agegrp == 15 ~ "65-69",
      agegrp == 16 ~ "70-74",
      agegrp == 17 ~ "75-79",
      agegrp == 18 ~ "80-84",
      agegrp == 19 ~ "85-89",
      agegrp == 20 ~ "90+",
      TRUE ~ NA
    )
    )
}