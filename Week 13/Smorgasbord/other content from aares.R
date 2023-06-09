
# Basic Linear Regression -------------------------------------------------
library(tidyverse)

diamonds

diamond_linear_model <- lm(price ~ cut + color + clarity + carat, data = diamonds)

diamond_linear_model

# install.packages("sjPlot")
# we will use this package to visualise 
library(sjPlot)

summary(diamond_linear_model)

#default tab model
tab_model(summary(diamond_linear_model))

# exploring 
tab_model(summary(diamond_linear_model),
          p.val = "wald", # pvalue
          show.df = F,    # degrees of freedom
          digits = 5,     # decimal places
          digits.re = 5,  # decimal places?
          show.ci=F,      # confidence interval
          show.icc = F,   #  
          show.stat = F #,
          #file = "RevlmextendedWTAVG.html"
          )

# pvalue is a stat test

# modeltime--------------------------------------------------------------------- 
# https://cran.r-project.org/web/packages/modeltime/index.html

# Modeltime combines both machine learning and time series modelling in one 
# handy package.

# https://www.rdocumentation.org/packages/modeltime/versions/1.2.4
# this shows the different modelling (ARIMA/ETS/Random Forest/)

# https://cran.r-project.org/web/packages/modeltime/vignettes/getting-started-with-modeltime.html

# Modeltime forecasting---------------------------------------------------------

#install.packages("modeltime")
#install.packages("tidymodels")
#install.packages("lubridate")
library(modeltime)
library(tidymodels)
library(tidyverse)
library(timetk)
library(lubridate)

?bike_sharing_daily
bike_sharing_daily

# Modeltime workflow:
#   1) Split data into training and test
#   2) Create and fit models
#   3) Create model table
#   4) Calibrate models
#   5) Perform testing set evaluation
#   6) Refit models to full dataset and forecast


# 1) Selecting the timeseries date variable and the one we want to visualise
bike_data <- bike_sharing_daily %>% 
  select(dteday, cnt)

interactive <- TRUE

bike_data %>% plot_time_series(.date_var = dteday, .value = cnt, .interactive = interactive)

# this is a plotly (opposed to ggplot visualisation) which means we can interact  
# with it. But we can turn it off with the interactive arg which calls the
# interactive object


splits <- time_series_split(
  data = bike_data, # specifying data 
  date_var = dteday, # specifying the date variable
  assess = "3 months", # specifying the assessment sample
  cumulative = TRUE) # allowing resampling to change the size of the training set

# 2) Create and fit models

## First lets fit an ARIMA 
model_arima <- arima_reg() %>% 
  set_engine(engine = "auto_arima") %>% 
  fit(cnt ~ dteday, data = training(splits))

model_arima

## Second lets fit a Boosted ARIMA
model_boosted_arima <- arima_boost(
  min_n = 2, #min. data points for for node to split
  learn_rate = 0.015 #rate boosting algorithm adapts each iteration
) %>% 
  set_engine(engine = "auto_arima_xgboost") %>% 
  fit(cnt ~ dteday + as.numeric(dteday),
      data = training(splits))

model_boosted_arima

## Third lets fit an Error-Trend Season (ETS) model
model_ets <- exp_smoothing() %>% 
  set_engine(engine = "ets") %>% 
  fit(cnt ~ dteday, data = training(splits))


model_ets

## Fourth lets fit a Prophet model
model_prophet <- prophet_reg() %>% 
  set_engine(engine = "prophet") %>% 
  fit(cnt ~ dteday, data = training(splits))

model_prophet
## Fifth lets fit a Linear Regression

model_linear_regression <- linear_reg() %>% 
  set_engine(engine = "lm") %>% 
  fit(
    cnt ~ as.numeric(dteday) + 
      factor(month(dteday, label = T),
             ordered = F),
    data = training(splits)
  )

model_linear_regression

# 3) Creating the modeltime table
tbl_models <- modeltime_table(
  model_arima,
  model_boosted_arima,
  model_ets,
  model_prophet,
  model_linear_regression)


tbl_models

# 4) Calibrate to testing sets

tbl_calibration <- tbl_models %>% 
  modeltime_calibrate(new_data = testing(splits))

# 5) Testing set evaluation
tbl_calibration %>% 
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = bike_data) %>% 
  plot_modeltime_forecast(
    .interactive = interactive
  )

modeltime_accuracy(tbl_calibration)

# 6) Refit to full data set and forecast forward
tbl_refit <- tbl_calibration %>% 
  modeltime_refit(data = bike_data)

tbl_refit %>% 
  modeltime_forecast(h = "3 weeks", actual_data = bike_data) %>% 
  plot_modeltime_forecast(
    .legend_max_width = 25
  )

# Now the models are refitted to the actual data. This is just a taste of what
# time series modelling can be like. There are numerous other models we can 
# employ too but for times sake I have shown 5 and the modeltime workflow.
