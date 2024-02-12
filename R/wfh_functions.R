#' Estimate WFH model (mlogit)
#' 
#' @param per Persons table
#' @param ... Arguments passed to `dplyr:: filter()`

estimate_wfh <- function(per, ...) {
	format_per <- per %>%
		filter(...) %>%
		dfidx(choice = "WRKLOC", shape = "wide")
		
	model <- mlogit(
		formula = WRKLOC ~ 0 |
			LIF_CYC_cat + HHVEHCNT_cat + HHFAMINC_cat + R_SEX,
		data = format_per,
		weights = format_per$WTPERFIN
	)
	
	return(model)
}

# estimate_wfh(
# 	zap_labels(per),
# 	as.integer(R_SEX) > 0,
# 	as.integer(HHFAMINC_cat) > 0
# )
