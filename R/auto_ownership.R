library(targets)
library(readxl)
library(ggplot2)
library(tidyverse)
library(mlogit)
library(MASS)
library(nnet)

# tar_load(utah_hhts_trips)
# 
# utah_hhts_unzip <- gzfile(utah_hhts_trips, "rt")
# 
# utah_hhts <- fread(utah_hhts_unzip, header = TRUE, sep = "\t")

# Read in the data
excel_file_path <- "C:\\Users\\ekbln\\OneDrive - Brigham Young University\\Desktop\\Winter 2024\\CE 694R\\utah_hhts.xlsx"

utah_hhts <- read_excel(excel_file_path) %>% 
  filter(CO_NAME == 'CACHE') %>% 
  dplyr::select(num_vehicles, hhsize, hh_income, workers) %>% 
  dfidx(shape = "wide", choice = "num_vehicles", sep = "")






  # mutate(num_vehicles = factor(num_vehicles, levels = 0:5, ordered = FALSE)) %>% 
  # mutate(hhsize = factor(hhsize, levels = 0:9, ordered = FALSE)) %>%
  # mutate(workers = factor(workers, levels = 0:4, ordered = FALSE)) %>%
  # mutate(hh_income = factor(hh_income, levels = 0:10, ordered = FALSE))



str(utah_hhts)

View(utah_hhts)

# Plots to see what the data is like
ggplot(utah_hhts, aes(x = num_vehicles)) +
  geom_histogram(binwidth = 1, fill = "darkblue", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Number of Vehicles Owned",
       x = "Number of Vehicles",
       y = "Frequency") +
  theme_minimal()

ggplot(utah_hhts, aes(x = as.factor(hhsize))) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Bar Chart of Household Size",
       x = "Household Size",
       y = "Frequency") +
  theme_minimal()

ggplot(utah_hhts, aes(x = as.factor(workers))) +
  geom_bar(binwidth = 1, fill = "darkgreen", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Workers",
       x = "Number of Workers",
       y = "Frequency") +
  theme_minimal()

ggplot(utah_hhts, aes(x = hh_income)) +
  geom_bar(binwidth = 1, fill = "darkred", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Income Levels",
       x = "Income Levels",
       y = "Frequency") +
  theme_minimal()

ggplot(utah_hhts, aes(x = hh_adults)) +
  geom_histogram(binwidth = 1, fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Household Adults",
       x = "Number of Adults",
       y = "Frequency") +
  theme_minimal()

ggplot(utah_hhts, aes(x = hh_children)) +
  geom_histogram(binwidth = 1, fill = "orange", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Household Children",
       x = "Number of Children",
       y = "Frequency") +
  theme_minimal()

ggplot(utah_hhts, aes(x = h_ATName)) +
  geom_bar(fill = "yellow", color = "black", alpha = 0.7) +
  labs(title = "Bar Chart of Household Type",
       x = "Household Type",
       y = "Frequency") +
  theme_minimal()

# Testing out some models

# Fit the Poisson regression
model_glm <- glm(num_vehicles ~ hhsize + workers + hh_income, data = utah_hhts, family = poisson)

# Summary of the model
summary(model_glm)   


model1 <- mlogit(num_vehicles ~ 1 | hhsize + workers + hh_income, data = utah_hhts)
