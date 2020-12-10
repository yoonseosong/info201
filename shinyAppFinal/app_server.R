#App Server Code

#Load Packages
library(tidyverse)
library(plotly)
library(shiny)

#Import data
dat <- read.csv("https://www.ahrq.gov/sites/default/files/wysiwyg/chsp/compendium/chsp-compendium-2018.csv", stringsAsFactors = FALSE)

#server
server <- function(input, output){
  output$map <- renderPlot({
    choice_name <- c("Physicians", "Primary care physicians", "Medical groups", 
                     "Hospitals", "Non-Federal general acute care hospitals", 
                     "Multistate system", "Beds", "Discharges", "Interns and residents")
    code_name <- c("physicians", "primary_care_physicians", "medical_groups", 
                   "hospitals", "non_federal_general_acute_care_hospitals", 
                   "multistate_system", "beds", "discharges", "interns_and_residents")
    column_names <- data.frame(choice_name, code_name)
    chosen_resource = column_names$code_name[choice_name == input$resource]
    state_sum <- dat %>% 
      group_by(health_sys_state) %>%
      summarize(physicians = sum(total_mds, na.rm = T),
                primary_care_physicians = sum(prim_care_mds, na.rm = T),
                medical_groups = sum(grp_cnt, na.rm = T),
                hospitals = sum(hosp_cnt, na.rm = T),
                non_federal_general_acute_care_hospitals = sum(acutehosp_cnt, na.rm = T),
                multistate_system = sum(sys_multistate, na.rm = T),
                beds = sum(sys_beds, na.rm = T),
                discharges = sum(sys_dsch, na.rm = T),
                interns_and_residents = sum(sys_res, na.rm = T)) %>% 
      mutate(fips = fips(health_sys_state))
    state_shape <- map_data("state") %>% 
      rename(state = region) %>% 
      mutate(fips = fips(state)) %>%
      left_join(state_sum, by = "fips")
    # Define a minimalist theme for map
    blank_theme <- theme_bw() +
      theme(
        axis.line = element_blank(),
        axis.text = element_blank(), 
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank()
      )
    # Draw the map using a map-based coordinate system
    resource_map <- ggplot(state_shape) +
      geom_polygon(
        mapping = aes(x = long, y = lat, group = group, fill = .data[[chosen_resource]]), 
        color = "black",
        size = 0.1
      ) +
      coord_map() +
      scale_fill_continuous(low = "white", high = "blue") +
      labs(title = input$resource,
           fill = input$resource) +
      blank_theme
    resource_map
  })
}
