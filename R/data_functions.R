#' Clean UT Household Travel Survey
#' 
#' @param ut_trips Trips file from UT HHTS
#' @param ut_hh HH file from UT HHTS
#' @param ut_taz TAZ file from UT HHTS
#' 
#' @return A list containing tables of the cleaned survey data
#'
#'@export
clean_ut_hhts <- function(ut_trips, ut_hh, ut_taz) {
	trips <- read_csv(ut_trips)
	hh <- read_csv(ut_hh)
	taz <- read_csv(ut_taz)
	
	
	
	return(
		list(
			# trips = cleaned_trips,
			# hh = cleaned_hh,
			# taz = cleaned_taz
		)
	)
}

#' Clean UT Household Travel Survey
#' 
#' @param ut_trips Trips file from UT HHTS
#' @param ut_hh HH file from UT HHTS
#' @param ut_taz TAZ file from UT HHTS
#' 
#' @return A list containing tables of the cleaned survey data
#' 
#' @export
clean_nhts <- function(nhts_trips, nhts_hh, nhts_per, nhts_veh) {
	trips <- read_sav(nhts_trips)
	hh <- read_sav(nhts_hh)
	per <- read_sav(nhts_per)
	veh <- read_sav(nhts_veh)
	
	cleaned_hh <- hh %>% 
		clean_nhts_hh_vars()
	
	cleaned_per <- per %>% 
		clean_nhts_hh_vars()
	
	return(
		list(
			# trips = cleaned_trips,
			hh = cleaned_hh,
			per = cleaned_per
			# veh = cleaned_veh
		)
	)
}


#' Clean HH vars from NHTS
#'
#' @param df Table to apply cleaning functions to
clean_nhts_hh_vars <- function(df){
	df %>% 
		mutate(
			HHFAMINC_cat = recode(
				HHFAMINC,
				"01" = "1", "02" = "1", "03" = "1", "04" = "1", "05" = "1",
				"06" = "2", "07" = "2",
				"08" = "3", "09" = "3",
				"10" = "4", "11" = "4",
				.combine_value_labels = TRUE
			),
			HHVEHCNT_cat = labelled(
				if_else(HHVEHCNT > 3, 3, HHVEHCNT),
				label = "Total number of vehicles in household"
			),
			LIF_CYC_cat = labelled(
				case_match(
					as.character(LIF_CYC),
					"03" ~ "1",
					"04" ~ "2",
					.default = "3"
				),
				c(
					"1 adult, youngest child 0-5" = "1",
					"2+ adults, youngest child 0-5" = "2",
					"No children 0-5" = "3")
			),
			label = "Simplified Life Cycle classification for the household"
		) %>% 
		filter(
			MSACAT == "03"
		)
}
