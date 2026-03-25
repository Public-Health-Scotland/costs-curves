#' recode_sfr
#'
#' Recode line numbers in the SFR in order to map costs to activity by specialty.
#' The specialty groupings in the SFRs are out of date with the current specialty
#' groups in SMR activity data, therefore this recoding is necessary to map costs
#' to activity as accurately as possible.
#'
#' @param sfr dataframe containing SFR data
#'
#' @returns `sfr_recode` dataframe with recoded specialties
#' @export
#'
#' @examples see below function
recode_sfr <- function(sfr){
  
  formname_str <- unique(sfr$formname)
  
  if(formname_str == "SFR 5.9"){
    # remove certain linenos (subtotals & unused) from SFR 5.9
    sfr_recode <- sfr |> 
      filter(!(lineno %in% c("310", "300", "260", "200", "190", "130", "110"))) |> 
      mutate(lineno = case_when(
        # Daypatients costs have different linenos, this part is converting the lineno 
        # to the equivalent outpatient lineno. 
        lineno == '280' ~ '255',
        lineno == '270' ~ '510',
        lineno == '250' ~ '400',
        lineno == '240' ~ '390',
        lineno == '220' ~ '370',
        lineno == '210' ~ '360',
        lineno == '180' ~ '330',
        lineno == '170' ~ '320',
        lineno == '160' ~ '310',
        lineno == '150' ~ '260',
        lineno == '140' ~ '250',
        lineno == '120' ~ '130',
        # additional recodes, needs to be done in this order
        lineno == '230' ~ '380',
        lineno == '290' ~ '230',
        TRUE ~ lineno))
   
    
  } else {
    # These are required for matching to SMR01 activity
    # combine general surgery (excluding vascular) and vascular surgery line numbers 
    # into one "dummy" line number (120)
    # combine cardiac surgery and thoracic surgery line numbers into one "dummy" 
    # line number (180)
    # combine general medicine specialties costed separately into the general 
    # medicine line number
    
    sfr_recode <- sfr |> 
      mutate(lineno = case_when(
        #"Clinical Oncology" merged with line 234 "Oncology" in 2019/20 Cost Book  
        lineno == '290' ~ '234',
        # combining general surgery (excluding vascular) and vascular surgery line  
        # numbers into one "dummy" line number (120)
        lineno == '121' ~ '120',
        lineno == '122' ~ '120',
        # combining cardiac surgery and thoracic surgery line numbers into one "dummy" 
        # line number (180)
        lineno == '181' ~ '180',
        lineno == '182' ~ '180',
        # combining general medicine specialties costed separately into the general 
        # medicine line number (230)
        lineno == '231' ~ '230',
        lineno == '345' ~ '230',
        TRUE ~ lineno))
    
  }
  
  return(sfr_recode)
}

# test <- recode_sfr(sfr_53)
# test2 <- recode_sfr(sfr_59)
