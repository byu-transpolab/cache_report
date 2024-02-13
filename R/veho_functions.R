#' Estimate vehicle ownership model (mlogit)
#' 
#' @param nhts_hh HH table from UT HHTS
#' @export
estimate_veho <- function(ut_hh) {
	format_hh <- ut_hh %>% 
		mutate(across(-c(weight), as.character)) %>% 
		dfidx(choice = "num_vehicles_cat", shape = "wide")
	# %>%  
	# 	unfold_idx() %>%
	# 	mutate(n_veh_cat = as.integer(levels(id2))[id2]) %>% 
	# 	mutate(
	# 		worker_diff = n_veh_cat - workers_cat,
	# 		adult_diff = n_veh_cat - hh_adults_cat
	# 	) %>% 
	# 	mutate(across(c(worker_diff, adult_diff), as.character)) %>%
	# 	select(-n_veh_cat) %>% 
	# 	fold_idx()

	null_model <- mlogit(
		formula = num_vehicles_cat ~ 1, 
		# formula = num_vehicles_cat ~ 0 | hh_income_cat + hh_adults_cat + hh_children,
		data = format_hh,
		weights = format_hh$weight
	)
	
	models <- list(
		update(null_model, . ~ . - 1 | hh_income_cat + hh_adults_cat),
		update(null_model, . ~ . - 1 | hh_income_cat + workers_cat),
		update(null_model, . ~ . - 1 | hh_income_cat),
		update(null_model, . ~ . - 1 | hh_adults_cat),
		update(null_model, . ~ . - 1 | workers_cat)
	)
	
	return(models)
}
