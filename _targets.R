#### Setup #############################################################

library(targets)
library(tarchetypes)
library(haven)

tar_option_set(
	packages = c("tidyverse", "wesanderson", "scales", "modelsummary", "mlogit", "broom", "labelled", "dfidx", "modelsummary"),
	# memory = "transient",
	# garbage_collection = TRUE,
	# format = "qs",
)

tar_source()

#### List targets ######################################################

# Misc ####
misc_targets <- tar_plan(
	plot_lims = list(x = c(-112.15,-111.6), y = c(40.2,40.8)),
)

# Data ####
data_targets <- tar_plan(
	tar_file(utah_hhts_trips, "data/ut_hhts/ut_hhts_2012_trip_data.csv.gz"),
	tar_file(utah_hhts_hh, "data/ut_hhts/ut_hhts_2012_hh_data.csv.gz"),
	tar_file(utah_hhts_taz, "data/ut_hhts/ut_hhts_2012_taz_data.csv.gz"),
	
	ut_hhts = clean_ut_hhts(
		trips = utah_hhts_trips,
		hh = utah_hhts_hh,
		taz = utah_hhts_taz
	),
	
	tar_file(nhts_hhpub, "data/nhts/HHPUB.sav.gz"),
	tar_file(nhts_perpub, "data/nhts/PERPUB.sav.gz"),
	tar_file(nhts_trippub, "data/nhts/TRIPPUB.sav.gz"),
	tar_file(nhts_vehpub, "data/nhts/VEHPUB.sav.gz"),
	
	nhts = clean_nhts(
		trips = nhts_trippub,
		hh = nhts_hhpub,
		per = nhts_perpub,
		veh = nhts_vehpub
	),
)

# Vehicle ownership ####
veho_targets <- tar_plan(
	# clean_veho = clean_veh_own(hhts_hh),
	# veho_summary = veh_own_summary(clean_veho),
	# veho_model = estimate_veho(clean_veho),
	veho_models = estimate_veho(ut_hhts$hh)
)


# Work From Home ####
wfh_targets <- tar_plan(
	#WFH
	wfh_models = estimate_wfh(haven::zap_labels(nhts$per)),

	# Telecommuting Frequency
	tc_models = estimate_tc(haven::zap_labels(nhts$per))
)


# Network ####
network_targets <- tar_plan(
	
	
)


# Mandatory location ####
mandatory_location_targets <- tar_plan(
	
)

# CDAP ####
cdap_targets <- tar_plan(
	
)

# Tours ####
tour_targets <- tar_plan(
	
)

# Trips ####
trip_targets <- tar_plan(
	
)


#### Run all targets ###################################################

tar_plan(
	misc_targets,
	data_targets,
	network_targets,
	wfh_targets,
	veho_targets,
	mandatory_location_targets,
	cdap_targets,
	tour_targets,
	trip_targets,
)
