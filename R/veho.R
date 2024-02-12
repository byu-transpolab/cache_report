#' Clean vehicle ownership data
#'
#' This function takes a dataset and performs data cleaning operations related to vehicle ownership.
#' It filters the dataset to only contain Cache County. It breaks the income groups into categories.
#' It then removes rows with missing values in 'hh_income_cat'. 
#' Finally, it selects specific columns ('num_vehicles_cat', 'hh_adults',
#' 'hh_income', and 'workers') from the cleaned dataset.
#'
#' @param data A data frame containing vehicle ownership data.
#' @return A cleaned data frame with selected columns.

clean_veh_own <- function(data) {
  clean_veho <- data %>% 
    filter(CO_NAME == 'CACHE') %>% 
    mutate(hh_income_cat = case_when(
      hh_income %in% 1:3 ~ "1",
      hh_income %in% 4:6 ~ "2",
      hh_income %in% 7:10 ~ "3")) %>% 
    dplyr::filter(!is.na(hh_income_cat)) %>%
    # mutate(ad_suff = if_else(hh_adults - num_vehicles < 0, 0, hh_adults - num_vehicles)) %>% 
           # wk_suff = if_else(workers - num_vehicles < 0, 0, workers - num_vehicles))
    dplyr::select(num_vehicles_cat, hh_income_cat, hh_adults, workers)
  
  return(clean_veho)
}


#' Summarize Vehicle Ownership Data
#'
#' This function takes a dataset and calculates summary statistics (mean and standard deviation)
#' for all variables in the dataset.
#'
#' @param data A data frame containing the raw data.
#'
#' @return A data frame containing the mean and standard deviation for each variable.

veh_own_summary <- function(data) {
  summary_table <- data %>%
    summarise_all(list(
      Mean = ~mean(.),
      St_Dev = ~sd(.)
    ))
  
  return(summary_table)
}


#' Estimate a multinomial logit model for vehicle ownership
#'
#' This function takes a dataset and estimates a multinomial logit model for vehicle ownership. It uses the
#' 'mlogit' function to fit the model with the specified formula and dataset. The model summary is then generated
#' using the 'modelsummary' function.
#'
#' @param data A data frame containing vehicle ownership data.
#' @return A summary of the estimated multinomial logit model.

estimate_veho <- function(data) {
  veho_model <- mlogit(
    formula = num_vehicles_cat ~ 1 | hh_income_cat + workers +hh_income_cat,
    data = data,
    shape = "wide",
    choice = "num_vehicles_cat",
    sep = ""
  )
  modelsummary(veho_model)
}
