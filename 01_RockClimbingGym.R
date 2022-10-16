### Static Options

my_palette = "Dark2"
box_height = 600

### Elements

## Daily Operations ##

# Membership Type Selector
membership_type_input = checkboxGroupInput(
  inputId = 'visits_member_filter',
  label = "Membership Type",
  choices = c('Members','Drop-ins'),
  selected = c('Members','Drop-ins')
  #size = 'md'
)

# Location selector
location_input = checkboxGroupInput(
  inputId = 'visits_location_selector',
  label = "Location",
  choices = c("Vancouver","Victoria"),
  selected = c("Vancouver","Victoria")
  # size = 'md'
)

# Day of week selector
day_of_week_selector = sliderTextInput(
  inputId = 'visits_day_selector',
  label = 'Days to Include',
  choices = wday(1:7,label=T,abbr=F),
  selected = wday(1:7,label=T,abbr=F)
)

# month selector
month_selector = sliderTextInput(
  inputId = 'visits_month_selector',
  label = 'Months to Include',
  choices = month(c(1:6),label=T,abbr=T),
  selected = month(c(1:6),label=T,abbr=T)
)

# Time scale selector
time_scale_selector = selectInput(
  inputId = 'visits_time_scale',
  label = 'Time Scale',
  choices = c("Day","Week","Month"),
  selected = "Day"
)

# Reset filters
reset_button = actionBttn(
  inputId = 'visits_reset_filters',
  label = "Reset filters",
  icon = icon('circle-left')
)

# Change method between average and sum
visits_math_mode_selector = radioButtons(
  inputId = 'visits_math_mode',
  label = "Method",
  choices = c("Average","Sum"),
  selected = "Average"
)

# Facet dropdown
visits_facet_selector = selectInput(
  inputId = 'visits_facet_option',
  label = "Split Plot by...",
  choices = c("none","location","month","day_of_week"),
  selected = "none"
)

rock_visitation_plotly_element = plotlyOutput('rock_visit_barplot', height = box_height)

## CFO CONTENT ## 

# Month selector
month_pick_input = tagList(
  tags$style(type = 'text/css', '#big_slider .irs-grid-text {font-size: 20px}'), 
  div(id = 'big_slider',
      sliderTextInput(
        inputId = 'months_picked',
        label = "",
        width = "100%",
        choices = month.abb[c(1:6)],
        selected = month.abb[c(5:6)]
      )
  )#div close
)#taglst close

# Membership line graph
membership_line_element = card(plotlyOutput('members_linegraph', height = 300))

# Employee line graph
employee_line_element = card(plotlyOutput('employee_linegraph', height = 300))

# Gross Profit Breakdown Line Graph
gross_prof_line_element = card(plotlyOutput('gross_profit_linegraph', height = 300))

### Design Blocks

# left_col_cfo = column(width = 7,
#                       card_grid(card_width = 1,
#                                 fixed_width = T,
#                                 card(
#                                   card_header("Gross Profit",
#                                               class = 'bg-success'),
#                                   card_body(gross_prof_line_element),
#                                   full_screen = T
#                                 ),
#                                 card(
#                                   card_header("Membership Trend",
#                                               class = 'bg-primary'),
#                                   card_body(membership_line_element),
#                                   full_screen = T
#                                 ),
#                                 card(
#                                   card_header("Number of Employees",
#                                               class = 'bg-info'),
#                                   card_body(employee_line_element),
#                                   full_screen = T,
#                                   width = 
#                                 )
#                       )
# )

figs_col_cfo = tabsetPanel(
  tabPanel(
    title = 'Gross Profit',
    gross_prof_line_element
  ),
  tabPanel(
    title = "Membership Trend",
    membership_line_element
  ),
  tabPanel(
    title = "Employees",
    employee_line_element
  )
)

summaries_rows = fluidRow(
  column(width = 6,
         h3("Vancouver", style = 'text-align:center;'),
         card_grid(
           card_width = 1/3,
           card(
             card_header("Revenue",
                         style = "font-size:22px;text-align:center;background-color:#1B9E77;color:white;"),
             card_body(
               div(textOutput('revenue_sum_van'), style = 'height:40px;font-weight:700;font-size:22px;text-align:center'),
               em(textOutput('revenue_change_van'))
             )
           ),
           card(
             card_header("Cost",
                         style = "font-size:22px;text-align:center;background-color:#D95F02;color:white;"),
             card_body(
               div(textOutput('cost_sum_van'), style = 'height:40px;font-weight:700;font-size:22px;text-align:center'),
               em(textOutput('cost_change_van'))
             )
           ),
           card(
             card_header("Gross Profit",
                         style = 'font-size:22px;text-align:center;background-color:#7570B3;color:white;'),
             card_body(
               div(textOutput('gross_profit_sum_van'), style = 'height:40px;font-weight:700;font-size:22px;text-align:center'),
               em(textOutput('gross_profit_change_van'))
             )
           )
         )
  ),
  column(width = 6,
         h3("Victoria", style = 'text-align:center;'),
         card_grid(
           card_width = 1/3,
           card(
             card_header("Revenue",
                         style = "font-size:22px;text-align:center;background-color:#1B9E77;color:white;"),
             card_body(
               div(textOutput('revenue_sum_vic'), style = 'height:40px;font-weight:700;font-size:22px;text-align:center'),
               em(textOutput('revenue_change_vic'))
             )
           ),
           card(
             card_header("Cost",
                         style = "font-size:22px;text-align:center;background-color:#D95F02;color:white;"),
             card_body(
               div(textOutput('cost_sum_vic'), style = 'height:40px;font-weight:700;font-size:22px;text-align:center'),
               textOutput('cost_change_vic')
             )
           ),
           card(
             card_header("Gross Profit",
                         style = 'font-size:22px;text-align:center;background-color:#7570B3;color:white;'),
             card_body(
               div(textOutput('gross_profit_sum_vic'), style = 'height:40px;font-weight:700;font-size:22px;text-align:center'),
               textOutput('gross_profit_change_vic')
             )
           )
         )
  )
)

rock_gym_daily = tabPanel(
  "Rock Gym - Daily Operations",
  icon = icon('warehouse'),
  sidebarLayout(
    sidebarPanel(
      bslib::accordion(
        accordion_item(
          "Apply Filters",
          day_of_week_selector,
          month_selector,
          location_input,
          membership_type_input,
          reset_button
        )
      ),
      accordion(
        accordion_item(
          selected = I("none"),
          "Change Plot Options",
          time_scale_selector,
          visits_math_mode_selector,
          visits_facet_selector
        )
      )
    ),
    mainPanel(
      h1("Rock Gym: British Columbia's finest Gym of Rocks."),
      HTML("<br><br>"),
      rock_visitation_plotly_element
      # dataTableOutput('data_test')
    )
  )
)

# OG style with accordions and summary numbers at top.
# rock_gym_cfo = tabPanel(
#   title = "CFO Summary",
#   h2("Rock Gym CFO Dashboard (Q1 and Q2, 2022)"),
#   top_row_cfo,
#   middle_row_cfo
# )

rock_gym_cfo = tabPanel(
  title = "Rock Gym - CFO Summary",
  icon = icon('coins'),
  sidebarLayout(
    sidebarPanel(
      h3("Months to Assess:"),
      month_pick_input,
      width = 3
    ),
    mainPanel(
      width = 9,
      h1("Rock Gym: British Columbia's finest Gym of Rocks."),
      HTML("<br><br>"),
      fluidRow(
        figs_col_cfo
      ),
      summaries_rows
      # )
    )
  )
)
# rock_gym = navbarMenu(
#   title = "Rock Gym",
#   rock_gym_daily,
#   rock_gym_cfo,
#   icon = icon('warehouse')
# )