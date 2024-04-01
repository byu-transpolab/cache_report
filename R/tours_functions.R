library(dplyr)
library(tidyr)

clean_tours <- function(tours) {
	split_tours <- tours %>%
		mutate(TourStart = if_else(TourType == "Incomplete", "Incomplete", str_split(TourType, "-", simplify = TRUE)[,1]),
					 TourEnd = if_else(TourType == "Incomplete", "Incomplete", str_split(TourType, "-", simplify = TRUE)[,2])) %>%
		mutate(TourTypeMod = case_when(
			TourStart == "Home" & TourEnd == "Home" ~ "home",
			TourStart == "Home" & TourEnd == "Work" ~ "work",
			TourStart == "Work" & TourEnd == "Home" ~ "work",
			TRUE ~ TourType
		))

	return(split_tours)
}

result <- clean_tours(ut_hhts$trips)




