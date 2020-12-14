#App Server Code

#Load Packages
library(tidyverse)
library(plotly)
library(shiny)
library(usmap)
library(maps)
library(mapproj)

#Import data
dat <- read.csv("https://www.ahrq.gov/sites/default/files/wysiwyg/chsp/compendium/chsp-compendium-2018.csv")
state_dat <- read.csv("https://www2.census.gov/programs-surveys/popest/tables/2010-2019/state/asrh/sc-est2019-alldata5.csv",
                      stringsAsFactors = FALSE)
#select data & sum of variables by state
scatterData <- dat %>%
  select(sys_beds, total_mds, sys_dsch, health_sys_state) %>%
  group_by(health_sys_state) %>%
  summarize(sum_total_beds = sum(sys_beds),
            sum_total_mds = sum(total_mds),
            sum_total_dsch = sum(sys_dsch))

#server
server <- function(input, output){
  
  output$map <- renderPlotly({
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
        mapping = aes(x = long, y = lat, group = group, fill = .data[[chosen_resource]],
                      text = sprintf("state: %s", health_sys_state)), 
        color = "black",
        size = 0.1
      ) +
      coord_map() +
      scale_fill_continuous(low = "white", high = "blue") +
      labs(title = input$resource,
           fill = input$resource) +
      blank_theme
    ggplotly(resource_map)
  })
  
  output$pie <- renderPlotly({
    
    state_dat_selected <- state_dat %>% 
      group_by(NAME, RACE) %>% 
      summarize(pop = sum(POPESTIMATE2018, na.rm = T)) %>% 
      filter(NAME == input$state) %>% 
      mutate(RACE = toString(RACE))
    
    state_dat_selected[1,2] <- "White"
    state_dat_selected[2,2] <- "Black"
    state_dat_selected[3,2] <- "American Indian"
    state_dat_selected[4,2] <- "Asian"
    state_dat_selected[5,2] <- "Pacific Islander"
    
    plot_ly(data=state_dat_selected,labels=~RACE, values=~pop, type="pie") %>% 
      layout(title = paste("Racial Demographics in", input$state),
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  output$pop <- renderText({
    
    state_dat_selected <- state_dat %>% 
      group_by(NAME) %>% 
      summarize(pop = sum(POPESTIMATE2018, na.rm = T)) %>% 
      filter(NAME == input$state)
    
    paste("Total population:", format(state_dat_selected$pop,big.mark = ",", scientific = F))
  })
  
  output$scatter <- renderPlotly ({
    sPlot <- plot_ly(scatterData, x = ~sum_total_beds, y = ~sum_total_mds, z = ~sum_total_dsch,
                     color =~ health_sys_state) %>% 
      filter(health_sys_state %in% input$State) %>% 
      group_by(health_sys_state) %>% 
      add_markers()
    sPlot <- sPlot %>% layout(scene = list( xaxis = list(title = 'Total Beds'),
                                            yaxis = list(title = 'Total Physicians'),
                                            zaxis = list(title = 'Total Discharges')))
    sPlot
   
  })
}
