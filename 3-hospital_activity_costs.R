#' 0-hospital-activity-costs.R 
#' NRAC Formula - HCHS - Age Sex & MLC
#' Code written September 2024
#' Health Finance & Analytics Team
#' 
#' This script takes cost data from the 3 latest costed years available via 
#' the SFRs. The SFR data is read in, line numbers recoded and the bbcosts 
#' output file is saved for both 1 year & 3 years.
#' 
#' The 1 year output is used by both age-sex and MLC, the 3 year output is required
#' for MLC only.
#' 
#' TODO - the code doesn't use SFR 5.8 but should consider changing this 
# for the 2026/27 run. We end up excluding some activity from SMR00 which could 
# match to costs in SFR 5.8 e.g. physiotherapy. See comments in script 4
# '4-SMR00_costbook_matching'.
#' 
#' TODO - includes Borders fix for 22/23 and 23/24 since there is missing data 
#' for these years - need to consider if this will apply to future runs and update
#' `borders_excl_years` accordingly
#' 
# 00. Housekeeping -------------------------------------------------------------

# source(here::here("R", "set-up", "set-up.R"))

start_vars <- ls()

# costs years with missing borders data
# borders_excl_years <- c("2223", "2324")

# 01. Loading SFR files, renaming columns and joining them---------------------

# sfr53 <- read_sfr53(hchs_age_sex_inputs$sfr53) %>% 
#   rename(exp = col19, no_of_discharges = col3, occupied_bed_days = col2) %>%
  # mutate(year_id = costed_year_latest) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, occupied_bed_days, year_id)

# sfr53_1 <- read_sfr53(hchs_mlc_inputs$sfr53_year_minus_1) %>% 
#   rename(exp = col19, no_of_discharges = col3, occupied_bed_days = col2) %>% 
#   mutate(year_id = costed_year_minus1) %>% 
#   select(unitcode, formname, lineno, exp, no_of_discharges, occupied_bed_days, year_id)
# 
# sfr53_2 <- read_sfr53(hchs_mlc_inputs$sfr53_year_minus_2) %>% 
#   rename(exp = col19, no_of_discharges = col3, occupied_bed_days = col2) %>% 
#   mutate(year_id = costed_year_minus2) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, occupied_bed_days, year_id)
# 
# sfr55 <- read_sfr55(hchs_age_sex_inputs$sfr55) %>% 
#   rename(exp = col17, no_of_discharges = col1) %>%
#   mutate(year_id = costed_year_latest) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr55_1 <- read_sfr55(hchs_mlc_inputs$sfr55_year_minus_1) %>% 
#   rename(exp = col17, no_of_discharges = col1) %>% 
#   mutate(year_id = costed_year_minus1) %>% 
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr55_2 <- read_sfr55(hchs_mlc_inputs$sfr55_year_minus_2) %>% 
#   rename(exp = col17, no_of_discharges = col1) %>% 
#   mutate(year_id = costed_year_minus2) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr57 <- read_sfr57(hchs_age_sex_inputs$sfr57) %>% 
#   rename(exp = col18, no_of_discharges = col2) %>%
#   mutate(year_id = costed_year_latest) %>%
#   select(unitcode,formname,lineno,exp,no_of_discharges, year_id)
# 
# sfr57_1 <- read_sfr57(hchs_mlc_inputs$sfr57_year_minus_1) %>% 
#   rename(exp = col18, no_of_discharges = col2) %>% 
#   mutate(year_id = costed_year_minus1) %>% 
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr57_2 <- read_sfr57(hchs_mlc_inputs$sfr57_year_minus_2) %>% 
#   rename(exp = col18, no_of_discharges = col2) %>% 
#   mutate(year_id = costed_year_minus2) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr57n <- read_sfr57n(hchs_age_sex_inputs$sfr57n) %>% 
#   rename(exp = col14, no_of_discharges = col2) %>%
#   mutate(year_id = costed_year_latest) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr57n_1 <- read_sfr57n(hchs_mlc_inputs$sfr57n_year_minus_1) %>% 
#   rename(exp = col14, no_of_discharges = col2) %>% 
#   mutate(year_id = costed_year_minus1) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr57n_2 <- read_sfr57n(hchs_mlc_inputs$sfr57n_year_minus_2) %>% 
#   rename(exp = col14, no_of_discharges = col2) %>% 
#   mutate(year_id = costed_year_minus2) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr59 <- read_sfr59(hchs_age_sex_inputs$sfr59) %>% 
#   rename(exp = col15, no_of_discharges = col1) %>%
#   mutate(year_id = costed_year_latest) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr59_1 <- read_sfr59(hchs_mlc_inputs$sfr59_year_minus_1) %>% 
#   rename(exp = col15, no_of_discharges = col1) %>% 
#   mutate(year_id = costed_year_minus1) %>% 
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)
# 
# sfr59_2 <- read_sfr59(hchs_mlc_inputs$sfr59_year_minus_2) %>% 
#   rename(exp = col15, no_of_discharges = col1) %>% 
#   mutate(year_id = costed_year_minus2) %>%
#   select(unitcode, formname, lineno, exp, no_of_discharges, year_id)

# adding the SFR files together 
# sfr_53<- bind_rows( sfr53, sfr53_1, sfr53_2,  sfr55, sfr55_1, sfr55_2, 
#                      sfr57, sfr57_1, sfr57_2, sfr57n, sfr57n_1, sfr57n_2,
#                      sfr59, sfr59_1, sfr59_2) %>%
#   # add providerider
#   mutate(provider = str_sub(unitcode, 1, 5))
# 
# rm(sfr53, sfr53_1, sfr53_2,  sfr55, sfr55_1, sfr55_2, 
#    sfr57, sfr57_1, sfr57_2, sfr57n, sfr57n_1, sfr57n_2,
#    sfr59, sfr59_1, sfr59_2)

# set NAs to 0
sfr_53[is.na(sfr_53)] <- 0


# 02. recoding of line numbers------------------------------------------------

# These are require for matching to SMR01 activity
# combine general surgery (excluding vascular) and vascular surgery line numbers 
# into one "dummy" line number (120)
# combine cardiac surgery and thoracic surgery line numbers into one "dummy" 
# line number (180)
# combine general medicine specialties costed separately into the general 
# medicine line number

sfr_recode <- sfr_53 %>% 
  mutate(lineno = case_when(
    #"Clinical Oncology" merged with line 234 "Oncology" in 2019/20 Cost Book  
    formname != "SFR 5.9" & lineno == '290' ~ '234',
    # combining general surgery (excluding vascular) and vascular surgery line  
    # numbers into one "dummy" line number (120)
    formname != "SFR 5.9" & lineno == '121' ~ '120',
    formname != "SFR 5.9" & lineno == '122' ~ '120',
    # combining cardiac surgery and thoracic surgery line numbers into one "dummy" 
    # line number (180)
    formname != "SFR 5.9" & lineno == '181' ~ '180',
    formname != "SFR 5.9" & lineno == '182' ~ '180',
    # combining general medicine specialties costed separately into the general 
    # medicine line number (230)
    formname != "SFR 5.9" & lineno == '231' ~ '230',
    formname != "SFR 5.9" & lineno == '345' ~ '230',
    TRUE ~ lineno))

# removing hospital specialty cost totals (lineno 550)
# sfr_recode %<>%
#   filter(lineno != "550")

# remove certain linenos (subtotals & unused) from SFR 5.9
# sfr_recode <- sfr_recode %>%
#   filter(!(formname == "SFR 5.9" & 
#              lineno %in% c("310", "300", "260", "200", "190", "130", "110")))

# selecting if net specialty cost not equal to 0
# sfr_recode %<>%
#   filter(exp != 0)

# aggregate to SFR lineno level
sfr_sum <- sfr_recode %>% 
  group_by(formname, lineno, year_id)  %>%
  summarise(exp = sum(exp), 
            no_of_discharges = sum(no_of_discharges), 
            occupied_bed_days = sum(occupied_bed_days)) %>%
  ungroup()

# rm(sfr_53, sfr_recode)

# 03. adding patient types------------------------------------------------------
# For inpatient (IP), day case or day(DC), outpatient(OP) which will later be
# coded with either I, D or O


# sfr_recode_2 <- sfr_sum %>%
#   mutate(ptype = case_when(
#     # inpatient data comes from SFR5.3 
#     formname == "SFR 5.3" ~ 'IP',
#     # daycase from SFR 5.5
#     formname == "SFR 5.5" & lineno != '430' & lineno != '440' ~ 'DC',
#     # Add daycase no_of_dischargestetrics Specialist and no_of_dischargestetrics GP to inpatient figures
#     # (SFR 5.5 lineno 430 and 440)
#     formname == "SFR 5.5" & lineno == '430'  ~ 'IP',
#     formname == "SFR 5.5" & lineno == '440'  ~ 'IP',
#     # outpatient data comes from SFR 5.7, 5.7n and 5.9
#     formname == "SFR 5.7"  ~ 'OP',
#     formname == "SFR 5.7N"  ~ 'OP',
#     formname == "SFR 5.9"  ~ 'OP',
#     TRUE ~ NA_character_
#   ))

# Daypatients costs have different linenos, this part is converting the lineno 
# to the equivalent OP lineno. 
# sfr_recode_2 %<>%
#   mutate(lineno = case_when(
#     formname == "SFR 5.9" & lineno == '280' ~ '255',
#     formname == "SFR 5.9" & lineno == '270' ~ '510',
#     formname == "SFR 5.9" & lineno == '250' ~ '400',
#     formname == "SFR 5.9" & lineno == '240' ~ '390',
#     formname == "SFR 5.9" & lineno == '220' ~ '370',
#     formname == "SFR 5.9" & lineno == '210' ~ '360',
#     formname == "SFR 5.9" & lineno == '180' ~ '330',
#     formname == "SFR 5.9" & lineno == '170' ~ '320',
#     formname == "SFR 5.9" & lineno == '160' ~ '310',
#     formname == "SFR 5.9" & lineno == '150' ~ '260',
#     formname == "SFR 5.9" & lineno == '140' ~ '250',
#     formname == "SFR 5.9" & lineno == '120' ~ '130',
#     TRUE ~ lineno))

# CHORE: check all the codes where they are getting reassigned to see if they are
# additional recode in specific order
# sfr_recode_2 %<>%
#   mutate(lineno = case_when(
#     formname == "SFR 5.9" & lineno == '230' ~ '380',
#     formname == "SFR 5.9" & lineno == '290' ~ '230',
#     TRUE ~ lineno))

# 04.Create ipdc variable ------------------------------------------------------
sfr_recode_2$ipdc <- substr(sfr_recode_2$ptype,1,1)  

bbcosts_temp <-sfr_recode_2 %>%
  group_by(ipdc, lineno, year_id)  %>%
  summarise(bbcost = sum(exp), 
            bbno_of_discharges = sum(no_of_discharges), 
            bboccbed = sum(occupied_bed_days))  %>%
  ungroup()

rm(sfr_recode_2, sfr_sum)

# 05. match on fixed/variable costs split for Acute ----------------------------

fixed_var_ratios_acute <- read_Fixed_Variable_Ratios_Acute(
  hchs_age_sex_inputs$Fixed_Variable_Ratios_Acute) 

fixed_var_ratios_mat <- read_Fixed_Variable_Ratios_Maternity(
  hchs_age_sex_inputs$Fixed_Variable_Ratios_Maternity) 

# joining acute and maternity cost ratios together
acute_mat <- rbind(fixed_var_ratios_acute, fixed_var_ratios_mat) 

bbcosts_3yr <- bbcosts_temp %>%
  left_join(acute_mat, by = c("ipdc", "lineno"))

# 06. Calculate fixed and variable costs ---------------------------------------
# distributing fixed and variable costs according to the variable and costs
# ratio proportions derived from the acute and maternity files above
bbcosts_3yr %<>%
  mutate(bbfixed = bbcost * fixed / 100)

bbcosts_3yr %<>%
  mutate (bbvar = bbcost * variable / 100)

#' Check that all inpatient costs have a fixed/variable breakdown,
#' this should be all inpatient rows except line nos 330 (cote) and 360-400 (mhld)
#' If there are any others the fixed / variable lookups may need adjusted.
check_na_costs <- bbcosts_3yr %>% 
  filter(ipdc == "I", is.na(variable)|is.na(fixed),
         !lineno %in% c("330", "360", "370", "380", "390", "400")) %>% 
  nrow()

if(check_na_costs != 0){
  stop("There are inpatient costs without a fixed variable breakdown. Update the lookups: \n -hchs_age_sex_inputs$Fixed_Variable_Ratios_Acute \n -hchs_age_sex_inputs$Fixed_Variable_Ratios_Maternity \n\n")
}

# 07. save outputs --------------------------------------------------------------
# save out Hospital Activity costs file

# set NAs to 0 
bbcosts_3yr[is.na(bbcosts_3yr)] <- 0

bbcosts_3yr %<>%
  select(ipdc, lineno, year_id, bbcost, bbfixed, bbvar, bbno_of_discharges, bboccbed)

bbcosts_1yr <- bbcosts_3yr %>%
  filter(year_id == costed_year_latest)

# Age-sex and MLC use the same costs data, save a copy in both the age-sex and
# mlc intermediary outputs folders

# age-sex
write_rds(bbcosts_1yr %>% select(-year_id), hchs_age_sex_inputs$bb_costs)

cat(paste0("saved bbcosts_", version_suffix, ".rds at"), 
    normalizePath(paste0(age_sex, "/intermediate/")), "\n", fill = TRUE)

# mlc
write_rds(bbcosts_1yr, hchs_mlc_inputs$bbcost_1yr)
write_rds(bbcosts_3yr, hchs_mlc_inputs$bbcost_3yr)

cat(paste0("saved bbcosts_1yr_", version_suffix, ".rds at"),
    normalizePath(paste0(HCHS, "/mlc/cost_ratios/")), "\n", fill = TRUE)

cat(paste0("saved bbcosts_3yr_", version_suffix, ".rds at"),
    normalizePath(paste0(HCHS, "/mlc/cost_ratios/")), "\n", fill = TRUE)

# 08. clean environment --------------------------------------------------------

rm(list = setdiff(ls(), start_vars))  
