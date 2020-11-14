#Calculations of Summary Information

#Import Tables
hc <- read.csv("https://www.ahrq.gov/sites/default/files/wysiwyg/chsp/compendium/chsp-compendium-2018.csv", stringsAsFactors = FALSE)


#column names
#number of rows
#number of columns
colnames(hc)
nrow(hc)
ncol(hc)

#summary function
summary(hc)

#get sum info
hc_summary <- get_summary_info(hc)

##Calculated Values

# maximum beds (state)
max_sys_beds <- hc %>%
  filter(sys_beds == max(sys_beds)) %>%
  pull(health_sys_state)

# minimum beds (state)
min_sys_beds <- hc %>%
  filter(sys_beds == min(sys_beds)) %>%
  pull(health_sys_state)

# state with most medics
health_sys_state_max_mds <- hc %>%
  group_by(health_sys_state)  %>%
  summarize(total = sum(total_mds)) %>%
  filter(total == max(total)) %>%
  pull(health_sys_state)

# most medics
max_total_mds <- hc %>%
  filter(total_mds == max(total_mds)) %>%
  pull(health_sys_city)

# least medics
min_total_mds <- hc %>%
  filter(total_mds == min(total_mds)) %>%
  pull(health_sys_city)

# sum of medics by state
sum_total_mds <- hc %>%
  group_by(health_sys_state) %>%
  summarize(sum_total_mds = sum(total_mds))
