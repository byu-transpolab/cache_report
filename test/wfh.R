##### TESTING #####

ggplot(nhts_per, aes(x = WKFMHM22)) +
	geom_bar(fill = "skyblue", color = "black") +
	labs(title = "Bar Chart of WKFMHM22",
			 x = "WKFMHM22",
			 y = "Frequency") +
	theme_minimal()

ggplot(nhts_per, aes(x = HHFAMINC)) +
	geom_bar(fill = "pink", color = "black") +
	labs(title = "Bar Chart of HHFAMINC",
			 x = "HHFAMINC",
			 y = "Frequency") +
	theme_minimal()

ggplot(nhts_per, aes(x = LIF_CYC)) +
	geom_bar(fill = "lightgreen", color = "black") +
	labs(title = "Bar Chart of LIF_CYC",
			 x = "LIF_CYC",
			 y = "Frequency") +
	theme_minimal()

ggplot(nhts_per, aes(x = HHVEHCNT)) +
	geom_bar(fill = "lightblue", color = "black") +
	labs(title = "Bar Chart of HHVEHCNT",
			 x = "HHVEHCNT",
			 y = "Frequency") +
	theme_minimal()


wfh_data <- nhts_per %>%
	dplyr::select(HOUSEID, PERSONID, CDIVMSAR, HHFAMINC, HHVEHCNT, LIF_CYC,
								R_SEX_IMP, WKFMHM22, WRKCOUNT, WORKER) %>%
	mutate(HHFAMINC = as.integer(HHFAMINC)) %>%
	mutate(HHFAMINC_cat = case_when(
		HHFAMINC %in% 1:5 ~ "1",
		HHFAMINC %in% 6:7 ~ "2",
		HHFAMINC %in% 8:9 ~ "3",
		HHFAMINC %in% 10:11 ~ "4")) %>%
	dplyr::filter(!is.na(HHFAMINC_cat)) %>%
	mutate(HHVEHCNT_cat = case_when(
		HHVEHCNT %in% 0 ~ "0",
		HHVEHCNT %in% 1 ~ "1",
		HHVEHCNT %in% 2 ~ "2",
		HHVEHCNT %in% 3:max(HHVEHCNT) ~ "3")) %>%
	dplyr::filter(!is.na(HHVEHCNT_cat)) %>%
	dplyr::filter(CDIVMSAR %in% c('13', '14', '23', '24', '33', '34', '43', '44',
																'53', '54', '63', '64', '73', '74', '83', '84',
																'93', '94')) %>%
	dplyr::filter(WORKER == '01') %>%
	dplyr::filter(WKFMHM22 != '-1')

ggplot(wfh_data, aes(x = WKFMHM22)) +
	geom_bar(fill = "skyblue", color = "black") +
	labs(title = "Bar Chart of WKFMHM22",
			 x = "WKFMHM22",
			 y = "Frequency") +
	theme_minimal()

ggplot(wfh_data, aes(x = HHFAMINC_cat)) +
	geom_bar(fill = "pink", color = "black") +
	labs(title = "Bar Chart of HHFAMINC_cat",
			 x = "HHFAMINC_cat",
			 y = "Frequency") +
	theme_minimal()

ggplot(wfh_data, aes(x = LIF_CYC)) +
	geom_bar(fill = "lightgreen", color = "black") +
	labs(title = "Bar Chart of LIF_CYC",
			 x = "LIF_CYC",
			 y = "Frequency") +
	theme_minimal()

ggplot(wfh_data, aes(x = HHVEHCNT_cat)) +
	geom_bar(fill = "lightblue", color = "black") +
	labs(title = "Bar Chart of HHVEHCNT_cat",
			 x = "HHVEHCNT_cat",
			 y = "Frequency") +
	theme_minimal()


wfh_data_model <- wfh_data %>%
	dfidx(shape = "wide", choice = "WKFMHM22", sep = "")


model <- mlogit(WKFMHM22 ~ 1 |HHFAMINC_cat + LIF_CYC + R_SEX_IMP + HHVEHCNT_cat, data = wfh_data_model)

summary(model)


#job type, grouped incomes, gender, life_stage, auto ownership, distance to work, worker status, num of adults in hh


library(haven)
pub <- read_spss("C:\\Users\\ekbln\\OneDrive - Brigham Young University\\Desktop\\Winter 2024\\CE 694R\\spss\\VEHPUB.sav")
View(pub)
