##### TESTING #####

# Plots to see what the data is like
ggplot(utah_hhts_data, aes(x = num_vehicles_cat)) +
  geom_histogram(binwidth = 1, fill = "darkblue", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Number of Vehicles Owned",
       x = "Number of Vehicles",
       y = "Frequency") +
  theme_minimal()

ggplot(utah_hhts_data, aes(x = hh_adults)) +
  geom_histogram(binwidth = 1, fill = "darkred", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Household Adults",
       x = "Number of Adults",
       y = "Frequency") +
  theme_minimal()

ggplot(utah_hhts_data, aes(x = as.factor(workers))) +
  geom_bar(binwidth = 1, fill = "darkgreen", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Workers",
       x = "Number of Workers",
       y = "Frequency") +
  theme_minimal()

ggplot(utah_hhts_data, aes(x = hh_income)) +
  geom_bar(binwidth = 1, fill = "darkorange", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Income Levels",
       x = "Income Levels",
       y = "Frequency") +
  theme_minimal()

utah_hhts <- read_excel(excel_file_path) %>%
  filter(CO_NAME == 'CACHE') %>%
  dplyr::select(num_vehicles_cat, hh_adults, hh_income, workers) %>%
  dfidx(shape = "wide", choice = "num_vehicles_cat", sep = "")

# Testing out some models
model1 <- mlogit(num_vehicles_cat ~ 1 | factor(hh_adults) + factor(workers) + factor(hh_income), data = utah_hhts)
summary(model1)
