#' human_cbdcs_colnames
#'
#' @param sfr dataframe of an SFR form, must have the column `formname` with a single constant value
#' 
#' @returns the human-friendly column names of the SFR data
#' @export
#'
#' @examples see below the function
human_cbdcs_colnames <- function(sfr){
  
  formname_str <- unique(sfr$formname)
  
  # load column dictionary
  cbdcs_column_dictionary_sfr <- read_csv("reference_files/cbdcs_column_dictionary.csv",
                                          show_col_types = FALSE) |> 
    clean_names() |> 
    # filter the SFR form of interest and keep only the most recent version of the column description
    filter(cd_formname == formname_str & is.na(cd_end_fin_year)) |> 
    mutate(cd_snakecase_description = make_clean_names(cd_description), 
           cd_columnno = as.character(paste0("col", cd_columnno)))
  
  # replace column names with machine readable names from the CBDCS column dictionary
  
  # list columns to rename
  columns2rename <- colnames(sfr)[startsWith(colnames(sfr), "col")]
  
  # get their machine readable description
  new_column_names <- cbdcs_column_dictionary_sfr |> 
    # filter column names we want to rename
    filter(cd_columnno %in% columns2rename) |> 
    pull(cd_snakecase_description)
  # rename the columns in the sfr data
  colnames(sfr)[startsWith(colnames(sfr), "col")] <- new_column_names
  
  return(colnames(sfr))
}

# example
# colnames(sfr_53) <- human_cbdcs_colnames(sfr_53)
