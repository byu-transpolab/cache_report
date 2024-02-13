#' Estimate WFH model (mlogit)
#' 
#' @param nhts_per Persons table from NHTS
#' @export
estimate_wfh <- function(nhts_per) {
	format_per <- nhts_per %>%
		filter(
			as.integer(R_SEX) > 0,
			as.integer(HHFAMINC_cat) > 0,
			WORKER == "01", 
			!is.na(WRKLOC)
		) %>%
		dfidx(choice = "WRKLOC", shape = "wide")
		
	null_model <- mlogit(
		formula = WRKLOC ~ 1,
		data = format_per,
		weights = format_per$WTPERFIN
	)
	
	models <- list(
		update(null_model, . ~ . -1 | LIF_CYC_cat + R_SEX),
		update(null_model, . ~ . -1 | HHVEHCNT_cat + R_SEX),
		update(null_model, . ~ . -1 | LIF_CYC_cat + HHVEHCNT_cat + R_SEX),
		update(null_model, . ~ . -1 | HHFAMINC_cat + HHVEHCNT_cat + R_SEX),
		update(null_model, . ~ . -1 | LIF_CYC_cat + HHFAMINC_cat + R_SEX),
		update(null_model, . ~ . -1 | LIF_CYC_cat + HHVEHCNT_cat + HHFAMINC_cat + R_SEX)
	)

	return(models)
}
