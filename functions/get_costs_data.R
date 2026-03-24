#' get_costs_sfr_data
#'
#' @param cbdcs_year start of the financial year (eg 2023, for fin year 23/24)
#' @param sfr_names names of the sfr forms to extract from CBDCS
#'
#' @returns SFR sfr_data 
#' @export
#'
#' @examples see below the function
get_costs_data <- function(cbdcs_year, sfr_names) {

  sfr_names <- paste0( "('", paste0(sfr_names, collapse = "' , '"), "')")
  
  # Define the sfr_database connection with APXP
  connect <- odbc::dbConnect(odbc::odbc(),
                             dsn = "APXP",
                             uid = uid,
                             pwd = pwd
  )
  
  
  query <- paste0("SELECT T0.O_UNIFIED_HB AS provider, T0.O_LOCATION AS Location, T1.SF_FINANCIAL_YEAR AS
    YEARID, T2.CB_FORMNAME AS FORMNAME, T2.CB_LINENO AS LINENO, T2.CB_COL1 AS COL1, T2.CB_COL2 AS COL2,
    T2.CB_COL3 AS COL3, T2.CB_COL4 AS COL4, T2.CB_COL5 AS COL5, T2.CB_COL6 AS COL6, T2.CB_COL7 AS COL7,
    T2.CB_COL8 AS COL8, T2.CB_COL9 AS COL9, T2.CB_COL10 AS COL10, T2.CB_COL11 AS COL11, T2.CB_COL12 AS COL12,
    T2.CB_COL13 AS COL13, T2.CB_COL14 AS COL14, T2.CB_COL15 AS COL15, T2.CB_COL16 AS COL16, T2.CB_COL17 AS COL17,
    T2.CB_COL18 AS COL18, T2.CB_COL19 AS COL19 FROM CBDCS.ORGANISATION T0, CBDCS.SUBMITTED_FORMS T1, CBDCS.COSTBOOK_data T2
    WHERE SF_FINANCIAL_YEAR = ", cbdcs_year, "
                  and T2.CB_FORMNAME IN ", sfr_names, "
                  and T1.SF_ID = T2.CB_SF_ID and T0.O_ID = T1.SF_O_ID
                  and T1.SF_ID = T2.CB_SF_ID and T0.O_ID = T1.SF_O_ID")
  
  
  sfr_data <- odbc::dbGetQuery(connect, query) |> 
    tibble::as_tibble()|> 
    janitor::clean_names() |> 
    mutate(lineno = as.character(lineno)) |> 
    # remove borders data & the all specialties totals (line 550)
    filter(provider != "SBA20" , lineno != "550")

  # temporarily replace 0s with NA in order to get rid of empty columns
  sfr_data[sfr_data==0] <- NA
  
  sfr_data <- sfr_data |> 
    # remove completely empty columns
    remove_empty(which = "cols")
  
  # replace blank costs by 0 so that we can sum thing up without spawning NAs
  sfr_data[is.na(sfr_data)] <- 0
  
  # disconnect from database
  dbDisconnect(connect)
  
  return(sfr_data) 
}

# example
# get_costs_sfr_data(2023, "SFR 5.3")
