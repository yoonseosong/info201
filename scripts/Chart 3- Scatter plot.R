library(ggplot2)
library(dplyr)
library(tidyverse)

# Import Tables
hc <- read.csv("https://www.ahrq.gov/sites/default/files/wysiwyg/chsp/compendium/chsp-compendium-2018.csv", stringsAsFactors = FALSE)

# sum of beds by state
sum_total_beds <- hc %>%
  group_by(health_sys_state) %>%
  summarize(sum_total_beds = sum(sys_beds)) %>% 
  rename(state = health_sys_state)

# sum of discharges by state
sum_total_dsch <- hc %>%
  group_by(health_sys_state) %>%
  summarize(sum_total_dsch = sum(sys_dsch)) %>% 
  rename(state = health_sys_state)

# join data frames
join_beds_dsch <- left_join(sum_total_beds, sum_total_dsch)

# scatterplot of proportion of minorities to health care resources
prop_of_minorities <- ggplot(data= join_beds_dsch) +
  geom_point(mapping = aes(
    x = sum_total_dsch/1000 , y = sum_total_beds, col = state)) +
  labs(x= "Total discharges (by thousands)", y= "Total Beds", title = "Trends of Beds to Discharges")


