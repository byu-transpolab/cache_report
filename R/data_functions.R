#' Clean UT Household Travel Survey
#' 
#' @param trips Trips file from UT HHTS
#' @param hh HH file from UT HHTS
#' @param taz TAZ file from UT HHTS
#' 
#' @return A list containing tables of the cleaned survey data
#'
#' @export
clean_ut_hhts <- function(trips, hh, taz) {
	trips <- read_csv(trips)
	hh <- read_csv(hh)
	taz <- read_csv(taz)
	
	cleaned_trips <- trips %>% 
		select(
			hptripid,
			tripID, 
			hhmemberid, 
			trip_pur_t, 
			o_purp_t,
			d_purp_t, 
			oLoc,
			dloc,
			mode_t,
			TourID,
			TourStID,
			TourEndID, 
			TourType, 
			PA_AP,
			h_CO_NAME
		)
	
	cleaned_hh <- hh %>%
		mutate(
			# hh_id = record_ID,
			weight,
			hh_adults_cat = pmin(hh_adults, 4),
			workers_cat = workers4,
			hh_income_cat,
			num_vehicles_cat,
			is_children = hh_children > 0,
			hh_children = pmin(hh_children, 3),
			.keep = "none",
			.before = 1,
		)
	
	return(
		list(
			trips = cleaned_trips,
			hh = cleaned_hh
			# taz = cleaned_taz
		)
	)
}

#' Clean the National Household Travel Survey
#' 
#' @param trips Trips file from NHTS
#' @param hh HH file from NHTS
#' @param per Per file from NHTS
#' @param veh Veh file from NHTS
#' 
#' @return A list containing tables of the cleaned survey data
#' 
#' @export
clean_nhts <- function(trips, hh, per, veh) {
	trips <- read_sav(trips)
	hh <- read_sav(hh)
	per <- read_sav(per)
	veh <- read_sav(veh)
	
	cleaned_hh <- hh %>% 
		clean_nhts_hh_vars()
	
	cleaned_per <- per %>% 
		clean_nhts_hh_vars() %>% 
		mutate(WRKLOC_cat = case_when(
			WRKLOC == '03' ~ 1,
			WRKLOC == '-1' ~ NA,
			TRUE ~ 0
		))
	
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
