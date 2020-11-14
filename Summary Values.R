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

##Beds
##Physicians
##Hospitals
##Medical Groups
##Demographics by State

# min`: the minimum value of the column
# max`: the maximum value of the column
# mean`: the mean value of the column

get_col_info <- function(col_name, hc) {
  distinctive_values <- (n_distinct(hc, hc[[col_name]], na.rm = TRUE))
  set_unique <- (unique(select(hc, col_name)))
  if (typeof(hc[[col_name]]) == "double") {
    val <- list(
      mean = mean(hc[[col_name]], na.rm = TRUE),
      min = min(hc[[col_name]], na.rm = TRUE),
      max = max(hc[[col_name]], na.rm = TRUE)
    )
  } 
  return(val)
}


# returns list of information for each column (column name)
# values are the summary information returned by `get_col_info()

get_summary_info <- function(hc) {
  hc_colnames <- as.list(colnames(hc))
  all_col_info <- lapply(hc_colnames, get_col_info, hc)
  names(all_col_info) <- hc_colnames
  return(all_col_info)
}

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
  group_by(healthy_sys_state) %>%
  summarize(total = sum(total_mds)) %>%
  filter(total == max(total)) %>%
  pull(health_sys_state)

# most medics
max_total_mds <- hc %>%
  filter(total_mds == max(total_mds)) %>%
  pull(health_sys_state)

# least medics
min_total_mds <- hc %>%
  filter(total_mds == min(total_mds)) %>%
  pull(health_sys_state)


