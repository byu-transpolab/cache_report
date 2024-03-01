#' Estimate vehicle ownership model (mlogit)
#' 
#' @param hh Households table from UT HHTS
#' @return A list of mlogit objects.
#' 
#' @details This dat
#' 
estimate_veho <- function(hh) {
	format_hh <- hh |> 
		mutate(hh_income_cat = factor(hh_income_cat, 
																	labels = c("Missing", "Low income", "Lower-middle", "Upper-middle", "High income"))) |> 
		dfidx(choice = "num_vehicles_cat", shape = "wide")

	null_model <- mlogit(
		formula = num_vehicles_cat ~ 1, 
		# formula = num_vehicles_cat ~ 0 | hh_income_cat + hh_adults_cat + hh_children,
		data = format_hh,
		weights = format_hh$weight
	)
	
	models <- list(
		update(null_model, . ~ . - 1 | hh_income_cat + workers_cat),
		update(null_model, . ~ . - 1 | hh_income_cat + hh_adults_cat + workers_cat)
	)
	
	return(models)
}
