library(flexdashboard)
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(shinyjs)
library(tidyverse)
library(ggiraph)
library(sf)
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)
library(plotly)
library(DT)
library(lubridate)
library(scales)
library(feedeR)
library(htmltools)
library(mailtoR)
#remotes::install_github('mdancho84/bslib')
#remotes::install_github('mdancho84/histoslider')
library(bslib)
library(histoslider)
library(bsicons)


rm(list = ls())

# setwd("F:/R Projects/cpmadsen.github.io/")

# box_height = 400
# halfbox_h = 250
plot_background_colour = "white"

source("bslib_attributes.R")
source("HelperFunctions.R")
source("00_MainPage.R")
source("01_01_RockClimbingDaily.R")
source("01_02_RockClimbingCFO.R")
source("02_BigFoot.R")
source("03_UK_Cycling.R")
source("04_AboutMe.R")
source("05_Contact.R")

theme_buttons = shiny::radioButtons(inputId = 'dark_mode', label = 'Theme', 
                                    choices = c("Light","Dark"), 
                                    selected = "Light",
                                    inline = T)

# Define UI for application that draws a histogram
ui = shiny::navbarPage(
  # tags$head(
  #   tags$style(HTML("
  #                   .navbar-brand {
  #                   display: flex;
  #                   }"))
  # ),
  
  theme = app_lightTheme,
  #fluid = T,
  useShinyjs(),
  
  # title = div(
  #   column(width = 12,
  #          tagList(
  #            h2("Madsen Data Viz", icon('chart-simple'))
  #          )),
  #   column(width = 12,
  #          theme_buttons)
  # ),
  
  title = tagList(h2("Madsen Data Viz", icon('chart-simple'))),
  
  main_page,
  
  navbarMenu(
    title = "Portfolio",
    rock_gym_daily,
    rock_gym_cfo,
    bigfoot_panel,
    uk_cycling
  ),
  about_me_panel,
  contact_panel,
  # header = fluidRow(
  #   column(width = 6,
  #          tagList(
  #            h2("Madsen Data Viz", icon('chart-simple'))
  #          )
  #   ),
  #   column(width = 6,
  #          div(
  #            theme_buttons,style = 'text-align:right;')
  #   )
  # ),
  footer = div(
    fluidRow(
      h3("Contact Links",
         style = 'text-align:center;'),
      column(width = 1,
             theme_buttons
             ),
      column(width = 5,
             div(
               tags$a(
                 icon(name = 'envelope',
                      style = 'font-size:70px;'),
                 href = "mailto:madsen.chris26@gmail.com")),
             style = 'text-align:right;'),
      column(width = 6,
             div(
               tags$a(
                 icon(name = 'linkedin',
                      style = 'font-size:70px;'),
                 href = "https://www.linkedin.com/in/christopher-madsen-a164521a7/"))
      )
    )
  )
)
