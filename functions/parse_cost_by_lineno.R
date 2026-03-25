parse_cost_by_lineno <- function(sfr){
  
  # source required functions
  source("functions/recode_sfr.R")
  source("functions/add_patient_type_variable.R")
  
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

  # sum costs by line number and patient type
  costs_by_lineno <- costs_by_lineno |> 
    group_by(ipdc, lineno) |> 
    summarise(across(where(is.numeric), ~sum(.x)), .groups = "drop") |> 
    pivot_longer(where(is.numeric) & !starts_with(standard_colname),
                 names_to = "staff_type", values_to = "cost") |>
    # setting fixed/variable costs to 100% fixed
    mutate(fixed_costs_prop = 1, variable_costs_prop = 0) |> 
    # calculate fixed and variable costs
    mutate(fixed_cost = cost * fixed_costs_prop, 
           variable_cost = cost * variable_costs_prop)
  
  return(costs_by_lineno)
}

# test <- parse_cost_by_lineno(sfr_53)

