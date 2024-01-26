#### Setup #####################################################################

library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("tidyverse", "wesanderson", "scales"),
  # memory = "transient",
  # garbage_collection = TRUE,
  # format = "qs",
)

sapply(list.files("R", full.names = TRUE), source)

#### List targets ##############################################################

# Misc ####
misc_targets <- tar_plan(
  plot_lims = list(x = c(-112.15,-111.6), y = c(40.2,40.8)),
)

# Data ####
data_targets <- tar_plan(
  tar_file(utah_hhts, "data/ut_hhts_2012.xlsb"),
  hhts = readxl::read_excel(utah_hhts, sheet = 1),
  taz_se = readxl::read_excel(utah_hhts, sheet = "TAZ")
)

# Network ####
network_targets <- tar_plan(
  
)


# Remote work ####
wfh_targets <- tar_plan(
  
)

# Vehicle ownership ####
veho_targets <- tar_plan(
  
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
