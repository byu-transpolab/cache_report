#### Setup #####################################################################

library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("tidyverse", "sf", "ggspatial", "wesanderson", "scales", "od"),
  # memory = "transient",
  # garbage_collection = TRUE,
  # format = "qs",
)

r_files <- list.files("R", full.names = TRUE)
sapply(r_files, source)


#### List targets ##############################################################

# Misc ####
misc_targets <- tar_plan(
  plot_lims = list(x = c(-112.15,-111.6), y = c(40.2,40.8)),
)

# Data ####
data_targets <- tar_plan(
  
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

