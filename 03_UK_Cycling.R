### Measurements used throughout the UI design.

uk_cyclingaccs = read_sf("data/cyclingUK/uk_cyclingaccidents.gpkg")
uk_map_height = '500px'
half_uk_map_h = '400px'

### Elements within the tab

# 1. Year selector for data.
uk_year_selector_element = 
  tagList(
    #tags$style(type = 'text/css', '#big_slider .irs-grid-text {font-size: 20px}'),
    div(id = 'big_slider',
        sliderInput(inputId = 'uk_cycling_year',
                    label = '',
                    min = min(uk_cyclingaccs$year),
                    max = max(uk_cyclingaccs$year),
                    value = 2005,
                    animate = T,
                    width = '90%',
                    sep = "")
    )
  )

# 2 Summary Cards (6)
uk_summary_cards = card_grid(
  card_width = 1/2,
  card(card_header("Fatal Accidents",
                  class = 'bg-danger', 
                  style = 'font-size:18px;text-align:center'),
       card_body(textOutput('uk_fatal_accidents')), 
       style = 'font-size:18px;text-align:center'),
  card(card_header("Total Projects Funded",
                  class = 'bg-success', 
                  style = 'font-size:18px;text-align:center'),
       card_body(textOutput('uk_tot_proj')), 
       style = 'font-size:18px;text-align:center'),
  card(card_header("Total Accidents",
                  class = 'bg-secondary', 
                  style = 'font-size:18px;text-align:center'),
       card_body(textOutput('uk_total_accidents')), 
       style = 'font-size:18px;text-align:center'),
  card(card_header("DFT Funding",
                  class = 'bg-info', 
                  style = 'font-size:18px;text-align:center'),
       card_body(textOutput('uk_tot_df_t_funding')), 
       style = 'font-size:18px;text-align:center'),
  card(card_header("Serious Accidents",
                  class = 'bg-warning', 
                  style = 'font-size:18px;text-align:center'),
       card_body(textOutput('uk_serious_accidents')), 
       style = 'font-size:18px;text-align:center'),
  card(card_header("Total Scheme Cost",
                  class = 'bg-primary', 
                  style = 'font-size:18px;text-align:center'),
       card_body(textOutput('uk_tot_scheme_cost')), 
       style = 'font-size:18px;text-align:center')
)

# 3. Map for center of dashboard tab.
uk_cycling_map_element = card(
  card_header(tagList(shiny::icon("map")," Cycling Accidents in England"),
             class = 'bs-primary',
             style = "font-size:1.76rem;font-weight:500"),
  leafletOutput('uk_cycling_leaflet', height = uk_map_height)
)

# 4. Linegraph of accidents by region
uk_cycling_linegraph_element = card(
  # card_header(tagList(shiny::icon("circle")," Accidents by Region Linegraph"),
  #            class = 'info'),
  plotlyOutput('cycling_lineplot', height = half_uk_map_h),
  numericInput(inputId = 'number_lines',label = 'Number of Regions Shown', 
               min = 3, max = 9, value = 5)
)

# 5. Bar plot of accidents by region
cycling_acc_region_barplot_element = card(
  #card_header(tagList(shiny::icon("circle")," Accidents by Region Barplot")),
  plotlyOutput('cycling_acc_region_barplot', height = half_uk_map_h)
)

### Design Blocks

uk_map_and_figures_block = fluidRow(
  column(width = 7,
         uk_cycling_map_element
  ),
  column(width = 5,
         h3("Number of Accidents..."),
         tabsetPanel(
           tabPanel(title = "By Region",cycling_acc_region_barplot_element),
           tabPanel(title = "By Region and Year",uk_cycling_linegraph_element)
         )
  )
)

uk_summary_block = fluidRow(
  uk_summary_cards
)

### Panel design

uk_cycling = tabPanel(
  title = 'UK Cycling Safety',
  sidebarLayout(
    sidebarPanel(
      accordion(
        accordion_item(
          title = "Dashboard Controls",
          uk_year_selector_element
        ),
        accordion_item(
          title = "Summary Stats",
          uk_summary_block
        )
      ),
      width = 3),
    mainPanel(
      h1("England's Journey to make Cycling Safer",
         style = 'font-align:center;'),
      HTML("<br><br>"),
      
      uk_map_and_figures_block,
      
      icon = icon('bicycle')
    )
  )
)