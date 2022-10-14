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

rm(list = ls())

# setwd("F:/R Projects/cpmadsen.github.io/")

box_height = 400
halfbox_h = 250

source("bslib_attributes.R")
source("HelperFunctions.R")
source("00_MainPage.R")
source("01_RockClimbingGym.R")
source("02_BigFoot.R")
source("03_UK_Cycling.R")

# Define UI for application that draws a histogram
ui = shiny::navbarPage(
  # tags$head(
  #   tags$style(HTML("
  #                   .navbar-brand {
  #                   display: flex;
  #                   }"))
  # ),
  
  theme = app_lighttTheme,
  
  #fluid = T,
  useShinyjs(),

  title = div(TITLE),
  main_page,
  rock_gym,
  bigfoot_panel,
  uk_cycling,
  footer = div(
    fluidRow(
      column(width = 6,
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
