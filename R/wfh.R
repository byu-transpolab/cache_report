#' Clean and filter the data for work from home analysis
#'
#' This function takes a dataset and performs cleaning and filtering operations
#' to prepare it for work from home analysis. It filters by MSASIZE, WORKER, and
#' WKFMHM22, converts variables to appropriate formats, and creates categorical
#' variables for analysis.
#'
#' @param data A data frame containing the raw data.
#'
#' @return A cleaned and filtered data frame ready for work from home analysis.

clean_wk_fm_hm <- function(data) {
  clean_wfh <- data %>% 
    filter(MSASIZE == '01') %>%
    filter(WORKER == '01') %>%
    # filter(WRKLOC == '03') %>% 
    mutate(LIF_CYC_cat = case_when(
      LIF_CYC == '03' ~ 1,
      LIF_CYC == '04' ~ 2,
      TRUE ~ 3
    )) %>% 
    mutate(HHFAMINC = as.integer(HHFAMINC)) %>% 
    mutate(HHFAMINC_cat = case_when(
      HHFAMINC %in% 1:5 ~ "1",
      HHFAMINC %in% 6:7 ~ "2",
      HHFAMINC %in% 8:9 ~ "3",
      HHFAMINC %in% 10:11 ~ "4"
    )) %>% 
    mutate(HHFAMINC_cat = as.numeric(HHFAMINC_cat)) %>%
    filter(!is.na(HHFAMINC_cat)) %>%
    mutate(HHVEHCNT_cat = case_when(
      HHVEHCNT %in% 0 ~ "0",
      HHVEHCNT %in% 1 ~ "1",
      HHVEHCNT %in% 2 ~ "2",
      HHVEHCNT %in% 3:max(HHVEHCNT) ~ "3"
    )) %>%
    mutate(HHVEHCNT_cat = as.numeric(HHVEHCNT_cat)) %>%
    filter(!is.na(HHVEHCNT_cat)) %>%
    select(MSASIZE, HHFAMINC_cat, HHVEHCNT_cat, LIF_CYC_cat, R_SEX_IMP, WKFMHM22, WRKLOC, WORKER) 
  
  return(clean_wfh)
}


#' Summarize Work from Home Data
#'
#' This function takes a dataset and calculates summary statistics (mean and standard deviation)
#' for all variables in the dataset.
#'
#' @param data A data frame containing the raw data.
#'
#' @return A data frame containing the mean and standard deviation for each variable.

wk_fm_hm_summary <- function(data) {
  summary_table <- data %>%
    summarise_all(list(
      Mean = ~mean(.),
      St_Dev = ~sd(.)
    ))
  
  return(summary_table)
}


#' Estimate Work from Home Model
#'
#' This function fits a multinomial logit model to estimate the probability of different 
#' work locations (WRKLOC) based on predictor variables, such as life cycle category 
#' (LIF_CYC_cat), household vehicle count category (HHVEHCNT_cat), household income 
#' category (HHFAMINC_cat), and respondent's sex (R_SEX_IMP).
#'
#' @param data A data frame containing the necessary variables for model estimation.
#'
#' @return A summary of the estimated multinomial logit model.

estimate_wfh <- function(data) {
  wfh_model <- mlogit(
    formula = WRKLOC ~ 1 | LIF_CYC_cat + HHVEHCNT_cat + HHFAMINC_cat + R_SEX_IMP,
    data = data,
    shape = "wide",
    choice = "WRKLOC",
    sep = ""
  )
  modelsummary(wfh_model)
}



##### TESTING #####

ggplot(nhts_per, aes(x = WKFMHM22)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Bar Chart of WKFMHM22",
       x = "WKFMHM22",
       y = "Frequency") +
  theme_minimal()

ggplot(nhts_per, aes(x = HHFAMINC)) +
  geom_bar(fill = "pink", color = "black") +
  labs(title = "Bar Chart of HHFAMINC",
       x = "HHFAMINC",
       y = "Frequency") +
  theme_minimal()

ggplot(nhts_per, aes(x = LIF_CYC)) +
  geom_bar(fill = "lightgreen", color = "black") +
  labs(title = "Bar Chart of LIF_CYC",
       x = "LIF_CYC",
       y = "Frequency") +
  theme_minimal()

ggplot(nhts_per, aes(x = HHVEHCNT)) +
  geom_bar(fill = "lightblue", color = "black") +
  labs(title = "Bar Chart of HHVEHCNT",
       x = "HHVEHCNT",
       y = "Frequency") +
  theme_minimal()


wfh_data <- nhts_per %>%
  dplyr::select(HOUSEID, PERSONID, CDIVMSAR, HHFAMINC, HHVEHCNT, LIF_CYC,
                R_SEX_IMP, WKFMHM22, WRKCOUNT, WORKER) %>%
  mutate(HHFAMINC = as.integer(HHFAMINC)) %>%
  mutate(HHFAMINC_cat = case_when(
    HHFAMINC %in% 1:5 ~ "1",
    HHFAMINC %in% 6:7 ~ "2",
    HHFAMINC %in% 8:9 ~ "3",
    HHFAMINC %in% 10:11 ~ "4")) %>%
  dplyr::filter(!is.na(HHFAMINC_cat)) %>%
  mutate(HHVEHCNT_cat = case_when(
    HHVEHCNT %in% 0 ~ "0",
    HHVEHCNT %in% 1 ~ "1",
    HHVEHCNT %in% 2 ~ "2",
    HHVEHCNT %in% 3:max(HHVEHCNT) ~ "3")) %>%
  dplyr::filter(!is.na(HHVEHCNT_cat)) %>%
  dplyr::filter(CDIVMSAR %in% c('13', '14', '23', '24', '33', '34', '43', '44',
                                '53', '54', '63', '64', '73', '74', '83', '84',
                                '93', '94')) %>%
  dplyr::filter(WORKER == '01') %>%
  dplyr::filter(WKFMHM22 != '-1')

ggplot(wfh_data, aes(x = WKFMHM22)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Bar Chart of WKFMHM22",
       x = "WKFMHM22",
       y = "Frequency") +
  theme_minimal()

ggplot(wfh_data, aes(x = HHFAMINC_cat)) +
  geom_bar(fill = "pink", color = "black") +
  labs(title = "Bar Chart of HHFAMINC_cat",
       x = "HHFAMINC_cat",
       y = "Frequency") +
  theme_minimal()

ggplot(wfh_data, aes(x = LIF_CYC)) +
  geom_bar(fill = "lightgreen", color = "black") +
  labs(title = "Bar Chart of LIF_CYC",
       x = "LIF_CYC",
       y = "Frequency") +
  theme_minimal()

ggplot(wfh_data, aes(x = HHVEHCNT_cat)) +
  geom_bar(fill = "lightblue", color = "black") +
  labs(title = "Bar Chart of HHVEHCNT_cat",
       x = "HHVEHCNT_cat",
       y = "Frequency") +
  theme_minimal()


wfh_data_model <- wfh_data %>%
  dfidx(shape = "wide", choice = "WKFMHM22", sep = "")


model <- mlogit(WKFMHM22 ~ 1 |HHFAMINC_cat + LIF_CYC + R_SEX_IMP + HHVEHCNT_cat, data = wfh_data_model)

summary(model)


#job type, grouped incomes, gender, life_stage, auto ownership, distance to work, worker status, num of adults in hh


library(haven)
pub <- read_spss("C:\\Users\\ekbln\\OneDrive - Brigham Young University\\Desktop\\Winter 2024\\CE 694R\\spss\\VEHPUB.sav")
View(pub)
