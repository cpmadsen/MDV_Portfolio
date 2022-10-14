### Measurements used throughout the UI design.

bigfoot_dat = read_sf("data/bigfoot_dat.gpkg")
bf_map_height = '500px'

### Elements within the tab

# 1. Map for center of dashboard tab.
bf_map_element = card(
  card_title(tagList(shiny::icon("paw"),"Bigfoot in the World             Change Options with Gear icon -->")), 
  # status = "success",
  # solidHeader = T,
  # width = 12,
  # height = bf_map_height,
  # sidebar = boxSidebar(),
  leafletOutput('bigfoot_map',height = bf_map_height)
)

# Controls for map.

map_controls_sidebar_panel = sidebarPanel(
  selectInput(inputId = "bigfoot_filter",
              label = "Select Area of Analysis",
              multiple = F,
              selectize = F,
              selected = c("Canada"),
              choices = c("Canada","USA","World")),
  sliderInput(inputId = "bigfoot_daterange",
              label = "Select Sighting Date Range",
              min = year(min(bigfoot_dat$most_recent_report)),
              max = year(max(bigfoot_dat$most_recent_report)),
              value = c(year(min(bigfoot_dat$most_recent_report)),
                        year(max(bigfoot_dat$most_recent_report))),
              timeFormat = "%YYYY",
              sep = "")
)

# 2. Vertical bar plot for beside map.
bf_vertbarplot_element = card(
  title = tagList(shiny::icon("map"),"Reports Broken Down by Region"), 
  # width = 12,
  # height = bf_map_height,
  numericInput(
    inputId = "binning_number",
    label = "Number of Groups to Show",
    value = 8,
    min = 1,
    max = 12
  ),
  plotlyOutput('bigfoot_barplot')
)     

# 3. Summary Blocks

bf_totalnumber_element = infoBoxOutput('total_summary')

bf_recentdate_element = infoBoxOutput('most_recent_date')

bf_recentplace_element = infoBoxOutput('most_recent_place')

# 4. Bigfoot in the news.
bfnews_element = card(
  title = tagList(shiny::icon("newspaper"),"Bigfoot in the News"),
  #gradient = T,
  # width = 12,
  # boxToolSize = 'sm',
  # color = 'red',
  #solidHeader = T,
  dataTableOutput('bigfoot_news_table')
) 

### Design Blocks

toprow_block = fluidRow(
  #column(width = 3, mapcontrol_element),
  column(width = 8, bf_map_element),
  column(width = 4, bf_vertbarplot_element)
)

middlerow_block = fluidRow(
  bf_totalnumber_element,
  bf_recentdate_element,
  bf_recentplace_element
)

bottomrow_block = fluidRow(bfnews_element)

### Panel design

bigfoot_panel = tabPanel(
  title = "Where in the World is Bigfoot?",
  icon = icon('paw'),
  sidebarLayout(
    sidebarPanel = map_controls_sidebar_panel,
    mainPanel(
      h2("Where in the World is Bigfoot?"),
      toprow_block,
      middlerow_block,
      bottomrow_block
    )
  )
)
