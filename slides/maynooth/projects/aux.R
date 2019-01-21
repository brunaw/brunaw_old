library(tidyverse)
da <- data.frame(vars = x1, y)
                 

da %>% 
  ggplot(aes(y = y, vars)) +
  geom_point(colour = 'red4', alpha = 0.65) +
  labs(y = "Y", x = "Covariable", title = "Simulated data for linear regression") +
  theme_bw()


logit_p = alpha + b1 * x1 + b2 * x2
p =  exp(logit_p)/(1+exp(logit_p)) # Inverse Logit
y <- rbinom(n = T, size = 1, prob = p)

da <- data.frame(p, vars = c(x1, x2), y,  
                 group = rep(c(1, 2), each = length(x1)))


da %>% 
  ggplot(aes(vars, y)) +
  geom_point(colour = 'red4', alpha = 0.65) +
  labs(y = "y", x = expression(paste("Covariables: ", x[1]," and ", x[2])), 
       title = "Simulated data for logistic regression") +
  facet_wrap(~group) +
  theme_bw()


da <- data.frame(p = logit_mu, vars = x1, y)

x0 <- rep(1,N)
x1 <- runif(N, 0, 10)
logit_mu <- alpha + beta * x1


da %>% 
  ggplot(aes(vars, y)) +
  geom_point(colour = 'red4', alpha = 0.65) +
  labs(y = 'y', x = "Covariable", 
       title = "Simulated data for Beta regression") +
  theme_bw()
