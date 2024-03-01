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
		mutate(
			children = case_when(
				LIF_CYC_cat %in% c(1, 2) ~ "Children less than 5",
				LIF_CYC_cat == 3 ~ "No children under 5",
			),
			female = ifelse(R_SEX == "02", TRUE, F),
			children = factor(children, levels = c("No children under 5", 
												"Children less than 5")),
			tc_frequency = case_when(
				WKFMHM22 == "01" ~ "Never", 
				WKFMHM22 %in% c("02") ~ "One or two days", 
				WKFMHM22 %in% c("03") ~ "Three or four days",
				WKFMHM22 %in% c("04") ~ "Five or more days",
				
		)) |> 
		select(HOUSEID, PERSONID, WTPERFIN, children, tc_frequency, female, HHVEHCNT_cat, HHFAMINC_cat) |> 
		dfidx(choice = "tc_frequency", shape = "wide")
	
	null_model <- mlogit(
		formula = tc_frequency ~ 1,
		data = format_per,
		weights = format_per$WTPERFIN
	)
	
	models <- list(
		"basic" = update(null_model, . ~ . -1 | children + female),
		"Model 1" = update(null_model, . ~ . -1 | children + HHVEHCNT_cat),
		update(null_model, . ~ . -1 | children + HHVEHCNT_cat + female),
		update(null_model, . ~ . -1 | children + female + HHFAMINC_cat),
		update(null_model, . ~ . -1 | children*female + HHFAMINC_cat)
		# update(null_model, . ~ . -1 | LIF_CYC_cat + HHVEHCNT_cat + HHFAMINC_cat + R_SEX)
	)
	

	return(models)
}
