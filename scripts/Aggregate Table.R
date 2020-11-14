hc <- read.csv("https://www.ahrq.gov/sites/default/files/wysiwyg/chsp/compendium/chsp-compendium-2018.csv", stringsAsFactors = FALSE)

summary <- hc %>% 
  group_by(health_sys_state) %>% 
  summarize(beds = sum(sys_beds, na.rm = T),
            medics = sum(total_mds, na.rm = T),
            hospitals = sum(hosp_cnt, na.rm = T),
            medical_groups = sum(grp_cnt, na.rm = T),
            discharge = sum(sys_dsch, na.rm = T))

