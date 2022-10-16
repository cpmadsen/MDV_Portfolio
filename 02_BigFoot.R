### Measurements used throughout the UI design.

bigfoot_dat = read_sf("data/bigfoot_dat.gpkg")
bf_map_height = '500px'

### Elements within the tab

# 1. Map for center of dashboard tab.
bf_map_element = card(
  leafletOutput('bigfoot_map',height = bf_map_height)
)

# Controls for map.

map_controls_sidebar_panel = sidebarPanel(
  selectInput(inputId = "bigfoot_filter",
              label = "Select Map Scale",
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
              sep = ""),
  width = '100%'
)

# 2. Vertical bar plot for beside map.
bf_vertbarplot_element = card(
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

bf_totalnumber_element = card(
  card_header("Total Reports",
             class = 'bg-primary',
             style = "font-size:22px;text-align:center;"),
  card_body(textOutput('total_summary'), style = 'font-weight:700;font-size:22px;text-align:center')
)

bf_recentdate_element = card(
  card_header("Most Recent Report",
             class = 'bg-warning',
             style = "font-size:22px;text-align:center;"),
  card_body(textOutput('most_recent_date'), style = 'font-weight:700;font-size:22px;text-align:center')
)

bf_recentplace_element = card(
  card_header("Most Recent Sighting",
             class = 'bg-info',
             style = "font-size:22px;text-align:center;"),
  card_body(textOutput('most_recent_place'), style = 'font-weight:700;font-size:22px;text-align:center')
)

# 4. Bigfoot in the news.
bfnews_element = card(
  card_header(tagList(shiny::icon("newspaper"),"Bigfoot in the News"),
             class = 'bg-warning',
             style = "font-size:22px;"),
  #gradient = T,
  # width = 12,
  # boxToolSize = 'sm',
  # color = 'red',
  #solidHeader = T,
  dataTableOutput('bigfoot_news_table')
) 

### Design Blocks

toprow_block = fluidRow(
  bf_map_element
)

middlerow_block = card_grid(
  card_width = 1/3,
  bf_totalnumber_element,
  bf_recentdate_element,
  bf_recentplace_element
)

bottomrow_block = fluidRow(bfnews_element)

### Panel design

bigfoot_panel = tabPanel(
  title = span(tagList(icon('paw'),"Where in the World is Bigfoot?")),
  fluidRow(
    h1("Where in the World is Bigfoot?"),
    style = 'text-align:center;'),
  sidebarLayout(
    sidebarPanel(
      accordion(
        selected = I("Reports Broken Down by Region"),
        accordion_item(
          "Map Tools",
          map_controls_sidebar_panel),
        accordion_item(
          "Reports Broken Down by Region",
          bf_vertbarplot_element))
    ),
    mainPanel(
      toprow_block,
      middlerow_block,
      bottomrow_block
    )
  )
)
