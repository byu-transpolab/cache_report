clean_ut_hhts <- function(ut_trips, ut_hh, ut_taz) {
	trips <- read_csv(ut_trips)
	hh <- read_csv(ut_hh)
	taz <- read_csv(ut_taz)
	
	
	
	return(
		list(
			trips = cleand_trips,
			hh = cleand_hh,
			taz = cleand_taz
		)
	)
}

clean_nhts <- function(nhts_trips, nhts_hh, nhts_per, nhts_veh) {
	trips <- read_sav(nhts_trips)
	hh <- read_sav(nhts_hh)
	per <- read_sav(nhts_per)
	veh <- read_sav(nhts_veh)
	
	
	
	return(
		list(
			trips = cleand_trips,
			hh = cleand_hh,
			per = cleand_per,
			veh = cleand_veh
		)
	)
}
