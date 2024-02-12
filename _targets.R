#### Setup #####################################################################

library(targets)
library(tarchetypes)
library(haven)

tar_option_set(
  packages = c("tidyverse", "wesanderson", "scales", "modelsummary", "mlogit"),
  # memory = "transient",
  # garbage_collection = TRUE,
  # format = "qs",
)

tar_source()

#### List targets ##############################################################

# Misc ####
misc_targets <- tar_plan(
  plot_lims = list(x = c(-112.15,-111.6), y = c(40.2,40.8)),
)

# Data ####
data_targets <- tar_plan(
  tar_file(utah_hhts_trips, "data/ut_hhts/ut_hhts_2012_trip_data.csv.gz"),
  hhts_trips = read_csv(utah_hhts_trips),
  tar_file(utah_hhts_hh, "data/ut_hhts/ut_hhts_2012_hh_data.csv.gz"),
  hhts_hh = read_csv(utah_hhts_hh),
  tar_file(utah_hhts_taz, "data/ut_hhts/ut_hhts_2012_taz_data.csv.gz"),
  hhts_taz = read_csv(utah_hhts_taz),
  
  tar_file(nhts_hhpub, "data/nhts/HHPUB.sav.gz"),
  nhts_hh = read_spss(nhts_hhpub),
  tar_file(nhts_perpub, "data/nhts/PERPUB.sav.gz"),
  nhts_per = read_spss(nhts_perpub),
  tar_file(nhts_trippub, "data/nhts/TRIPPUB.sav.gz"),
  nhts_trip = read_spss(nhts_trippub),
  tar_file(nhts_vehpub, "data/nhts/VEHPUB.sav.gz"),
  nhts_veh = read_spss(nhts_vehpub)
)

# Vehicle ownership ####
veho_targets <- tar_plan(
  clean_veho = clean_veh_own(hhts_hh),
  veho_summary = veh_own_summary(clean_veho),
  veho_model = estimate_veho(clean_veho)
)


# Work From Home ####
wfh_targets <- tar_plan(
  clean_wfh = clean_wk_fm_hm(nhts_per),
  wfh_summary = wk_fm_hm_summary(clean_wfh),
  wfh_model = estimate_wfh(clean_wfh)
)


# Telecommuting Frequency ####
wfh_targets <- tar_plan(
  
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


#### Run all targets ###########################################################

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
