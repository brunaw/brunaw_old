library(tidyverse)

# Data Fields -------------------------------------------------------
# datetime - hourly date + timestamp  
# season -  1 = spring, 2 = summer, 3 = fall, 4 = winter 
# holiday - whether the day is considered a holiday
# workingday - whether the day is neither a weekend nor holiday
# weather - 1: Clear, Few clouds, Partly cloudy, Partly cloudy 
# 2: Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist 
# 3: Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds 
# 4: Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog 
# temp - temperature in Celsius
# atemp - "feels like" temperature in Celsius
# humidity - relative humidity
# windspeed - wind speed
# casual - number of non-registered user rentals initiated
# registered - number of registered user rentals initiated
# count - number of total rentals
#--------------------------------------------------------------------


da <- read.csv('~/Maynooth University/Andrew Parnell - CDA_PhD/data/Kaggle/Bike sharing/train.csv') %>% 
  select(temp, humidity, season) %>% 
  mutate(season = as.factor(season))
head(da)

mean(da$humidity)
da %>% 
  ggplot(aes(x = humidity, y = temp)) +
  geom_point(colour = 'lightgreen', alpha = 0.75, size = 1.5) +
  geom_smooth(method = 'lm', colour = 'grey') +
  facet_wrap(~season) +
  theme_bw()

lm(temp ~ humidity +  factor(season), data = da) %>% summary()
lm(temp ~ humidity, data = da) %>% summary()

mm <- model.matrix(~ humidity + season, data = da)
k <-  ncol(mm)
n <- nrow(mm)
v <- solve(t(mm) %*% mm)
betas <- v %*% t(mm) %*% da$temp
betas


y_hat <- mm %*% betas
da$res <- da$temp - y_hat

da %>% 
  ggplot(aes(res)) +
  geom_density(colour = 'skyblue', size = 1.2, alpha = 0.75) +
  geom_vline(xintercept = 0, linetype = 'dotted') +
  theme_bw() +
  labs(x = 'residual')

# Estimated s2
s2 <- (t(da$res) %*% da$res)/(n-k)
  

# Simulations -------------------------------------------------------------
sim <- 1000
gamma <- rgamma(sim, shape = (n-k)/2, 
                rate = (n-k)*s2/2)

sigma <- 1/gamma
err <- sigma * MASS::mvrnorm(n = 1000, mu = rep(0, 5), v)
beta_sim <- rep(c(betas), each = 1000) + as.vector(err)
beta_sim <- beta_sim %>% as.data.frame() %>% 
  mutate(groups = rep(1:5, each = 1000))

vline <- function(group){
  geom_vline(data = filter(beta_sim, 
                           groups == group), 
             aes(xintercept = betas[group]), linetype = 'dotted') 
}

beta_sim %>% 
  ggplot(aes(.)) +
  geom_density(colour = 'skyblue', size = 1.1, alpha = 0.75) +
  1:5 %>% purrr::map(vline) +
  facet_wrap(~groups, scales = 'free') + 
  theme_bw()



