library(usmap)
library(ggplot2)

#Import Tables
hc <- read.csv("https://www.ahrq.gov/sites/default/files/wysiwyg/chsp/compendium/chsp-compendium-2018.csv", stringsAsFactors = FALSE)

# sum of medics by state
sum_total_mds <- hc %>%
  group_by(health_sys_state) %>%
  summarize(sum_total_mds = sum(total_mds)) %>% 
  mutate(fips = fips(health_sys_state))

plot_usmap(regions = "states", data = sum_total_mds, values = "sum_total_mds", color = "blue") + 
  scale_fill_continuous(
    low = "white", high = "blue", name = "number of mds", label = scales::comma
  ) + theme(legend.position = "right")