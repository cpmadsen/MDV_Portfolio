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

rm(list = ls())

# setwd("F:/R Projects/cpmadsen.github.io/")

box_height = 400
halfbox_h = 250

source("HelperFunctions.R")
source("00_MainPage.R")
source("01_RockClimbingGym.R")
source("02_BigFoot.R")
source("03_UK_Cycling.R")

# Define UI for application that draws a histogram
ui = shinydashboardPlus::dashboardPage(
  
  skin = 'black',
  
  #useShinyjs(),
  header = dashboardHeader(
    title = "Madsen Analytics"
  ),
  dashboardSidebar(
    div(sidebarMenu(
      id = 'tabs',
      div(tags$img(src = 'MDV_logo.png', height = 250),
          style = 'font-size:20px;text-align:center;margin-top:10px'),
      shinydashboard::menuItem(div(h4("Home")), tabName = 'home', badgeColor = "green"),
      shinydashboard::menuItem(div(h4("Rock Gym Dashboard")), tabName = "rock_gym"),
      shinydashboard::menuItem(div(h4("Where is Bigfoot?")), tabName = 'bigfoot'),
      shinydashboard::menuItem(div(h4('Traffic in the UK')), tabName = 'uk_cycling')
    )),
    width = 250),
  dashboardBody(
    tabItems(
      main_page,
      rock_gym,
      bigfoot_panel,
      uk_cycling
    ),
    tags$head(tags$style(HTML('* {font-family: "-webkit-body"};')))
  ),
  footer = dashboardFooter(
    left = fluidRow(
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
