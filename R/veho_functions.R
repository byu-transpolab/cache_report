#' Estimate vehicle ownership model (mlogit)
#' 
#' @param nhts_hh HH table from UT HHTS
#' @export
estimate_veho <- function(ut_hh) {
	format_hh <- ut_hh %>%
		filter(
			as.integer(hh_income_cat) > 0,
			CO_NAME == "CACHE"
		) %>%
		# mutate(across(c(hh_income_cat, workers4), as.character)) %>% 
		dfidx(choice = "num_vehicles_cat", shape = "wide")
	
	model <- mlogit(
		formula = num_vehicles_cat ~ 0 |
			workers4,
		data = format_hh,
		weights = format_hh$weight
	)
	
	summary(model)
	
	return(model)
}
