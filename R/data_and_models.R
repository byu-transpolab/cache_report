#' Make the car_mlogit estimation data
#' 
make_data <- function(){
  # load the car data from the mlogit package
  data("Car", package = "mlogit")
  
  # transform the data into an mlogit dataframe 
  car_mlogit <- Car |>
    mutate(choice = gsub("choice", "", choice)) |>
    dfidx( varying = 5:70, shape = "wide", choice = "choice", sep = "")
  
  # return data from function
  car_mlogit
}


#' Estimate models
#' 
#' @param car_mlogit The mlogit data frame returned by make_data
#' 
estimate_models <- function(car_mlogit){
  
  # first model: type and price
  model1 <- mlogit(choice ~ type + price | -1, data = car_mlogit)
  
  # second model: add range of vehicle
  model2 <- update(model1, .~. + range)
  
  # put models in a list and return
  models <- list("Model 1" = model1, "Model 2" = model2)
  models
  
}


