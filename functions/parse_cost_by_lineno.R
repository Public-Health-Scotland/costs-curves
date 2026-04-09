parse_cost_by_lineno <- function(sfr){
  
  # source required functions
  source("functions/recode_sfr.R")
  source("functions/add_patient_type_variable.R")
  
  # get formname
  my_formname <- unique(sfr$formname)
  
  # list of column names to standardise
  rogue_colnames <- c("no_of_discharges", "no_of_cases", "total_attendances", 
                      "no_of_attendances")
  
  standard_colname <- "no_of_episodes"
  
  # standardise column name
  colnames(sfr)[colnames(sfr) %in% rogue_colnames] <- standard_colname
  
  # recode SFR line numbers in order to more accurately match costs onto activity data
  costs_by_lineno <- recode_sfr(sfr)
  
  # add patient type variable
  costs_by_lineno <- add_patient_type_variable(costs_by_lineno)
  
  # add a column with total cost for all types of staff
  if(my_formname == "SFR 5.7N"){
    
    costs_by_lineno <- costs_by_lineno |> 
      
      # total costs for all types of staff
      mutate(all_staff = ahp_staff_direct_supplies_number +
            nursing_staff_number +
            other_direct_care_number + pharmacy_staff_direct_supplies_number
            )
      
  } else if (my_formname == "SFR 5.9"){
    costs_by_lineno <- costs_by_lineno |> 
      
      # total costs for all types of staff
      mutate(all_staff = ahp_staff_direct_supplies_number  + 
               medical_dental_staff_number + nursing_staff_number +
               other_direct_care_number + pharmacy_staff_direct_supplies_number)
    
  } else {
    
    costs_by_lineno <- costs_by_lineno |> 
      
      # total costs for all types of staff
      mutate(all_staff = ahp_staff_direct_supplies_number  + 
               medical_dental_staff_number + nursing_staff_number +
               other_direct_care_number + pharmacy_staff_direct_supplies_number +
               theatre_staff_direct_supplies_number)
    
  }

 

  costs_by_lineno <- costs_by_lineno |> 
    # aggregate by patient type and line number
    group_by(ipdc, lineno) |> 
    summarise(across(where(is.numeric), ~sum(.x)), .groups = "drop") |> 
    pivot_longer(where(is.numeric) & !starts_with(standard_colname),
                 names_to = "staff_type", values_to = "cost")
  
  return(costs_by_lineno)
}

# test <- parse_cost_by_lineno(sfr_57n)

