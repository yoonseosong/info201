#App UI Code

#Load Packages
library(shiny)
library(tidyverse)
library(plotly)
library(usmap)

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
  titlePanel("Compare the Sum of Beds, Physicians, and Discharges by State"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("State",
                     "Choose Your States",
                     unique(dat$health_sys_state),
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
  titlePanel("Number of Resources in Each State"),
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
      plotOutput("map")
    )
  )
)

# Interactive page- 3
page_four <- tabPanel(
  "Racial Demographics",
  titlePanel("Racial Demographics in Each State"),
  mainPanel(
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
      
      ## Key take away 1
      tags$h3("Significant Resource Gap")),
      
      # Paragraph
      tags$p("vv"),
      
      ## Key take away 2
      tags$h3("Key Takeaway #2"),
      
      # Paragraph
      tasg$p("vv"),
      
      ## Key take away 3
      tags$h3("Key takeway #3"),
      
      # Paragraph
      tags$p("vv")
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
