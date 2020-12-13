#App UI Code

#Load Packages
library(shiny)
library(tidyverse)
library(plotly)
library(usmap)

source("app_server.R")

# intro page
page_one <- tabPanel(
  "Introduction",
  mainPanel(
    includeCSS("style.css"),
    tags$body(
      tags$header(
        tags$h1("Growing Health Disparities in the U.S.")
      ),
      tags$img(src= "disparities.jpg", height = 315, width = 600),
      tags$h3("Introduction"),
      tags$p("The domain of the project focuses on disparities in demographics in 
      relation to healthcare in America. By analyzing data sets on health care 
      resources and racial demographics by state we can observe the correlation 
      between minority groups and their access to healthcare."),
      tags$p("Key questions we are seeking to answer to evaluate the trends in hospital
      resources and race include: "),
      tags$li("What are patterns that show up when comparing racial demographics
            to different resources?"),
      tags$li("How do these trends differ between states and resources?"),
      tags$li("What are important proportion to look at when evaluating common issues
            with the health care system?"),
      tags$p(" "),
      tags$p("To answer these key questions we focused our research specifically on
      the black and white populations as well as specific resources that we feel
      are the most crucial to the healthcare system such as medics, beds, and 
      physicians. This project proposal aims to seek resources that most affect 
      racial groups to find better solutions to healthcare across the US."),
      
      # Future projections
      tags$h3("Looking Towards the Future"),
      
      tags$img(src= "covid.jpg", height = 333.33, width = 575),
      
      tags$p("Looking towards the future we're interested in seeing how the results of 
      this data research project might change as new data on the effects of COVID-19
      in the healthcare system. It is important to note the changing circumstances
      of the U.S and how systemic racism continues to impact the lives of many. The goal
      of this project is to not only seek trends in data but to also seek solutions
      to combat the growing health disparities in America." )
    )
  )
)

# Interactive page- 1

page_two <- tabPanel(
  "Scatter",
  includeCSS("style.css"),
  tags$body(
    tags$header(
      tags$h1("Compare the Sum of Beds, Physicians, and Discharges by State")
    )
  ),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("State",
                     "Choose Your States",
                     unique(scatterData$health_sys_state),
                     selected = c("WA", "CA", "NY", "MN", "AL", "OH"),
                     multiple = TRUE
      )
    ),
    mainPanel(plotlyOutput("scatter"))
  )
)

# Interactive page- 2
# resource variable
page_three <- tabPanel(
  "Map",
  includeCSS("style.css"),
  tags$body(
    tags$header(
      tags$h1("Number of Resources in Each State")
    )
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "resource",
        label = "Choose a resource",
        choices = c("Physicians", "Primary care physicians", "Medical groups", 
                    "Hospitals", "Non-Federal general acute care hospitals", 
                    "Multistate system", "Beds", "Discharges", "Interns and residents"),
        selected = "Number of physicians"
      )
    ),
    mainPanel(
      plotlyOutput("map")
    )
  )
)

# Interactive page- 3
page_four <- tabPanel(
  "Pie",
  mainPanel(
    includeCSS("style.css"),
    tags$body(
      tags$header(
        tags$h1("Racial Demographics in Each State")
      )
    ),
    selectInput(
      inputId = "state",
      label = "Choose a State",
      choices = state.name
    ),
    plotlyOutput("pie")
  )
)


# Summary Takeaways
page_five <- tabPanel(
    "Summary",
    mainPanel(
      includeCSS("style.css"),
      tags$body(
        tags$header(
          tags$h1("Summary Takeaways")
        ),
      # img
      tags$img("", src= "healthcare.png", height = 240, width = 800)),
      
      tags$h3("Trends between racial demographics and resources"),
      
      # Paragraph
      tags$p("It is clear through the data and our visualization tools that there 
      is a correlation between health resources and racial demographics. For 
      instance, when comparing Nevada and Kansas using the scatter plot, two 
      states that have similar population sizes (NV: 3.08M, KS: 2.91M), Kansas 
      has significantly more beds, physicians, and discharges than Nevada. When 
      comparing the demographics of these two states, Nevada has a much larger 
      proportion of minorities than Kansas (Nevada is 25.6% nonwhite and Kansas 
      is only 15.4% nonwhite). Additionally, the map reveals that the most beds, 
      hospitals, and discharges are in Tennessee, which has a much smaller overall 
      population than California and New York, two states that have a much larger 
      proportion of minorities.
"),
      #images
      tags$img(src= "splot.png", height = 357, width = 544),
      tags$img(src= "race.png", height = 256, width = 504.67),
      
      ## Key take away 2
      tags$h3("Correlation of resources to discharges"),
      
      # Paragraph
      tags$p("Our visuals indicated the clear correlation between the hospital 
             resources to the total number of discharges by state. The common trend 
             in each state and shows that a higher level of resource density directly 
             relates to a higher number of patient discharges. Specifically, the 
             interactive map visualization showed that. California has the highest 
             number of physicians and medical groups but Tennessee has the highest 
             number of hospitals, beds, and discharges. This in connection with our 
             interactive scatterplot visualization presents the assumption that 
             discharges are more influenced by hospitals and beds more so than medics. 
             This was an important component of our data research and accomplished one 
             of our key questions of what resource is the most crucial to the 
             effectiveness of healthcare systems."),
      
      #images
      tags$img(src= "map1.png", height = 314, width = 533.5),
      tags$img(src= "map2.png", height = 314, width = 533.5),
      
      ## Key take away 3
      tags$h3("Comparing between states"),
      
      # Paragraph
      tags$p("Our visuals were all grouped by state to create a common factor to 
      compare our other variables. Though separately, our data visuals might not 
      necessarily indicate key components of our project set, by seeing the common 
      trends together you can see important data points where similar patterns arise. 
      In our 3D scatterplot visualization, we evaluated the total physicians and 
      total beds with total discharges by different states. This visualization 
      allows us to see the patterns and fluctuations between different states 
      through different variations on one plot. One trend we saw when comparing 
      the different states was __.")
    )
)



# ui server
ui <- fluidPage(
  navbarPage(
    "Healthcare Resource Disparities",
    page_one,
    page_two,
    page_three,
    page_four,
    page_five
  ))
