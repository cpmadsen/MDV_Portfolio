### Static Options

my_palette = "Dark2"
box_height = 600

### Elements

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
    )
  )
)