### Static Options

my_palette = "Dark2"
box_height = 400

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
location_input = bslib::input_check_buttons(
  id = 'visits_location_selector',
  choices = c("Vancouver","Victoria"),
  selected = c("Vancouver","Victoria"),
  size = 'md'
)

# Day of week selector
day_of_week_selector = sliderTextInput(
  inputId = 'visits_day_selector',
  label = 'Days to Include',
  choices = wday(1:7,label=T,abbr=F),
  selected = wday(1:7,label=T,abbr=F)
  )

# month selector
month_selector = checkboxGroupButtons(
  inputId = 'visits_month_selector',
  label = 'Days to Include',
  choices = wday(1:7,label=T,abbr=T),
  selected = wday(1:7,label=T,abbr=T),
  direction = 'vertical'
)

# Time scale selector
time_scale_selector = selectInput(
  inputId = 'visits_time_scale',
  label = 'Time Scale',
  choices = c("Day","Week","Month"),
  selected = "Month"
)

rock_visitation_plotly_element = plotlyOutput('rock_visit_barplot')

## CFO CONTENT ## 

# Month selector
month_pick_input = tagList(
  tags$style(type = 'text/css', '#big_slider .irs-grid-text {font-size: 20px}'), 
  div(id = 'big_slider',
      sliderTextInput(
        inputId = 'months_picked',
        label = "",
        choices = month.abb[c(1:6)],
        selected = month.abb[c(5:6)]
      )
  )#div close
)#taglst close

# Membership line graph
membership_line_element = plotlyOutput('members_linegraph', height = 400)

# Employee line graph
employee_line_element = plotlyOutput('employee_linegraph', height = 400)

# Gross Profit Breakdown Line Graph
gross_prof_line_element = plotlyOutput('gross_profit_linegraph', height = 400)

### Design Blocks

top_row_cfo = fluidRow(
  column(width = 6,
         h3("Vancouver"),
         fluidRow(valueBoxOutput('revenue_summary_van'),
                  valueBoxOutput('cost_summary_van'),
                  valueBoxOutput('gross_profit_summary_van')),
         h3("Victoria"),
         fluidRow(valueBoxOutput('revenue_summary_vic'),
                  valueBoxOutput('cost_summary_vic'),
                  valueBoxOutput('gross_profit_summary_vic'))
         ),
  column(width = 6,
         tabBox(title = "Charts",
                height = paste0(300,"px"),
                selected = 'Gross Profit',
                tabPanel("Gross Profit",gross_prof_line_element),
                tabPanel("Membership Trend",membership_line_element),
                tabPanel("Employees",employee_line_element),
                width = 12)
  )
)

rock_gym_daily = tabPanel(
  "Daily Operations",
  sidebarLayout(
    sidebarPanel(
      membership_type_input,
      location_input,
      bslib::accordion(
        accordion_item(
          "Test label",
          day_of_week_selector
        )
      ),
      time_scale_selector
    ),
    mainPanel(
      rock_visitation_plotly_element
    )
  )
)

rock_gym_cfo = tabPanel(
  title = "CFO Summary",
  h2("Rock Gym CFO Dashboard (Q1 and Q2, 2022)"),
  card(title = "Select Months to Compare", month_pick_input, #width = 12,
      collapsible = T, collapsed = T),
  top_row
)

rock_gym = navbarMenu(
  title = "Rock Gym",
  rock_gym_daily,
  rock_gym_cfo,
  icon = icon('warehouse'),
)