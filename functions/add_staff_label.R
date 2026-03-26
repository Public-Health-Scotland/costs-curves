#' add_staff_label
#'
#' add human labels to the staff type
#'
#' @param . dataframe must have a `staff_type`column
#'
#' @returns dataframe with an `staff_type_label` column
#' @export
#'
#' @examples
add_staff_label <- function(.){
  . |> 
    mutate(staff_type_label = case_when(
      staff_type == "ahp_staff_direct_supplies_number" ~ "AHP", 
      staff_type == "medical_dental_staff_number" ~ "Medical & Dental", 
      staff_type == "nursing_staff_number" ~ "Nursing", 
      staff_type == "other_direct_care_number" ~ "Other Direct Care", 
      staff_type == "pharmacy_staff_direct_supplies_number" ~ "Pharmacy", 
      staff_type == "theatre_staff_direct_supplies_number" ~ "Theatre",
      staff_type == "all_staff" ~ "All Staff", 
      TRUE ~ NA
    )
    )
}