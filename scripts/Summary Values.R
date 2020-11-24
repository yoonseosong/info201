#Calculations of Summary Information

#Import Tables
hc <- read.csv("https://www.ahrq.gov/sites/default/files/wysiwyg/chsp/compendium/chsp-compendium-2018.csv", stringsAsFactors = FALSE)

##Calculated Values

summary_info <- list()

# maximum beds (state)
summary_info$max_sys_beds <- hc %>%
  filter(sys_beds == max(sys_beds, na.rm = T)) %>%
  pull(health_sys_state)

# minimum beds (state)
summary_info$min_sys_beds <- hc %>%
  filter(sys_beds == min(sys_beds, na.rm = T)) %>%
  pull(health_sys_state)

# state with most medics
summary_info$health_sys_state_max_mds <- hc %>%
  group_by(health_sys_state)  %>%
  summarize(total = sum(total_mds)) %>%
  filter(total == max(total)) %>%
  pull(health_sys_state)

# most medics
summary_info$max_total_mds <- hc %>%
  filter(total_mds == max(total_mds)) %>%
  pull(health_sys_city)

# least medics
summary_info$min_total_mds <- hc %>%
  filter(total_mds == min(total_mds)) %>%
  pull(health_sys_city)

# sum of medics by state
summary_info$sum_total_mds <- hc %>%
  group_by(health_sys_state) %>%
  summarize(sum_total_mds = sum(total_mds))
