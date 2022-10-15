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
membership_line_element = plotlyOutput('members_linegraph', height = 300)

# Employee line graph
employee_line_element = plotlyOutput('employee_linegraph', height = 300)

# Gross Profit Breakdown Line Graph
gross_prof_line_element = plotlyOutput('gross_profit_linegraph', height = 300)

### Design Blocks

left_col_cfo = column(width = 7,
                      card_grid(card_width = 1,
                                fixed_width = T,
                                card(
                                  card_title("Gross Profit"),
                                  card_body(gross_prof_line_element),
                                  full_screen = T
                                ),
                                card(
                                  card_title("Membership Trend"),
                                  card_body(membership_line_element),
                                  full_screen = T
                                ),
                                card(
                                  card_title("Number of Employees"),
                                  card_body(employee_line_element),
                                  full_screen = T,
                                  width = 
                                )
                      )
)

van_sum_col_cfo = column(width = 2,
                         h3("Vancouver"),
                         card_grid(
                           card_width = 1,
                           card(
                             card_title("Revenue"),
                             card_body(
                               textOutput('revenue_sum_van'),
                               textOutput('revenue_change_van')
                             )
                           ),
                           card(
                             card_title("Cost"),
                             card_body(
                               textOutput('cost_sum_van'),
                               textOutput('cost_change_van')
                             )
                           ),
                           card(
                             card_title("Gross Profit"),
                             card_body(
                               textOutput('gross_profit_sum_van'),
                               textOutput('gross_profit_change_van')
                             )
                           )
                         )
)

vic_sum_col_cfo = column(width = 2,
                         h3("Victoria"),
                         card_grid(
                           card_width = 1,
                           card(
                             card_title("Revenue"),
                             card_body(
                               textOutput('revenue_sum_vic'),
                               textOutput('revenue_change_vic')
                             )
                           ),
                           card(
                             card_title("Cost"),
                             card_body(
                               textOutput('cost_sum_vic'),
                               textOutput('cost_change_vic')
                             )
                           ),
                           card(
                             card_title("Gross Profit"),
                             card_body(
                               textOutput('gross_profit_sum_vic'),
                               textOutput('gross_profit_change_vic')
                             )
                           )
                         )
)

# OG style with accordions and summary numbers at top.
# top_row_cfo = fluidRow(
#   month_pick_input,
#   column(width = 6,
#          h3("Vancouver"),
#          card_grid(
#            card(
#              card_title("Revenue"),
#              card_body(
#                textOutput('revenue_sum_van'),
#                textOutput('revenue_change_van')
#              )
#            ),
#            card(
#              card_title("Cost"),
#              card_body(
#                textOutput('cost_sum_van'),
#                textOutput('cost_change_van')
#              )
#            ),
#            card(
#              card_title("Gross Profit"),
#              card_body(
#                textOutput('gross_profit_sum_van'),
#                textOutput('gross_profit_change_van')
#              )
#            )
#          )
#   ),
#   column(width = 6,
#          h3("Victoria"),
#          card_grid(
#            card(
#              card_title("Revenue"),
#              card_body(
#                textOutput('revenue_sum_vic'),
#                textOutput('revenue_change_vic')
#              )
#            ),
#            card(
#              card_title("Cost"),
#              card_body(
#                textOutput('cost_sum_vic'),
#                textOutput('cost_change_vic')
#              )
#            ),
#            card(
#              card_title("Gross Profit"),
#              card_body(
#                textOutput('gross_profit_sum_vic'),
#                textOutput('gross_profit_change_vic')
#              )
#            )
#          )
#   )
# )
# 
# middle_row_cfo = fluidRow(
#   column(width = 12,
#          accordion(
#            accordion_item(
#              title = "Gross Profit",
#              card(
#                card_body(gross_prof_line_element),
#                full_screen = T
#              )
#            ),
#            accordion_item(
#              title = "Membership Trend",
#              card(
#                card_body(membership_line_element),
#                full_screen = T
#              )
#            ),
#            accordion_item(
#              title = "Employees",
#              card(
#                card_body(employee_line_element),
#                full_screen = T
#              )
#            )
#          )
#   )
# )

rock_gym_daily = tabPanel(
  "Daily Operations",
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
  title = "CFO Summary",
  sidebarLayout(
    sidebarPanel(
      h3("Months to Assess:"),
      month_pick_input,
      width = 2
    ),
    mainPanel(
      fluidRow(
        left_col_cfo,
        van_sum_col_cfo,
        vic_sum_col_cfo
      )
    )
  )
)
rock_gym = navbarMenu(
  title = "Rock Gym",
  rock_gym_daily,
  rock_gym_cfo,
  icon = icon('warehouse'),
)