#' add_patient_type_variable
#'
#' @param sfr dataframe containing SFR data, must have a column colled `formname` with the name of the SFR form
#'
#' @returns `sfr` with an additional variable called `ipdc` which contains a character label for patient type
#' @export
#'
#' @examples see below function
add_patient_type_variable <- function(sfr){
  
  sfr_patient_type <- sfr |> 
    mutate(ipdc = case_when(
      # inpatient data comes from SFR5.3 
      formname == "SFR 5.3" ~ 'I',
      # daycase from SFR 5.5
      formname == "SFR 5.5" & lineno != '430' & lineno != '440' ~ 'D',
      # Add daycase Obstetrics Specialist and Obstetrics GP to inpatient figures 
      # (SFR 5.5 lineno 430 and 440)
      formname == "SFR 5.5" & lineno == '430'  ~ 'I',
      formname == "SFR 5.5" & lineno == '440'  ~ 'I',
      # outpatient data comes from SFR 5.7, 5.7n and 5.9
      formname == "SFR 5.7"  ~ 'O',
      formname == "SFR 5.7N"  ~ 'O',
      formname == "SFR 5.9"  ~ 'O',
      TRUE ~ NA
    ))
  
  return(sfr_patient_type)
  
}
# test <- add_patient_type_variable(sfr_55)