#' Estimate TC model (mlogit)
#' 
#' @param nhts_per Persons table from NHTS
#' @export
estimate_tc <- function(nhts_per) {
	format_per <- nhts_per %>%
		filter(
			as.integer(R_SEX) > 0,
			as.integer(HHFAMINC_cat) > 0,
			WORKER == "01", 
			WRKLOC_cat == 0
		) %>%
		
		dfidx(choice = "WKFMHM22", shape = "wide")
	
	model <- mlogit(
		formula = WKFMHM22 ~ 0 |
			LIF_CYC_cat + HHVEHCNT_cat + HHFAMINC_cat + R_SEX,
		data = format_per,
		weights = format_per$WTPERFIN
	)
	
	summary(model)
	
	return(model)
}
