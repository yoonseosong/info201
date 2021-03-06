# download / load packages
# install.packages("usmap")
library(dplyr)
library(usmap)
library(ggplot2)

# import data
hc <- read.csv("https://www.ahrq.gov/sites/default/files/wysiwyg/chsp/compendium/chsp-compendium-2018.csv", stringsAsFactors = FALSE)

# sum of medics by state
sum_total_mds <- hc %>%
  group_by(health_sys_state) %>%
  summarize(sum_total_mds = sum(total_mds)) %>% 
  mutate(fips = fips(health_sys_state))

# create map
mds_map <- plot_usmap(regions = "states", data = sum_total_mds, values = "sum_total_mds", color = "black") + 
  scale_fill_continuous(
    low = "white", high = "blue", name = "number of MDs", label = scales::comma
  ) + theme(legend.position = "right") +
  labs(
    title = "Number of physicians in each state"
  )
