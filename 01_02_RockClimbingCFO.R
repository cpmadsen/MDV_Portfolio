### Static Options

my_palette = "Dark2"
box_height = 400

### Elements

# Month selector
month_pick_input = tagList(
  tags$style(type = 'text/css', '#big_slider .irs-grid-text {font-size: 20px}'), 
  div(id = 'big_slider',
      sliderTextInput(
        inputId = 'months_picked',
        label = "",
        width = "100%",
        choices = month.abb[c(1:6)],
        selected = month.abb[c(4,6)]
      )
  )#div close
)#taglst close

# Membership line graph
membership_line_element = card(plotlyOutput('members_linegraph', height = box_height/2))

# Employee line graph
employee_line_element = card(plotlyOutput('employee_linegraph', height = box_height/2))

# Gross Profit Breakdown Line Graph
gross_prof_line_element = card(plotlyOutput('gross_profit_linegraph', height = box_height))

### Design Blocks

van_summary_block = column(
  width = 12,
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
)

vic_summary_block = column(
  width = 12,
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

month_selector_col = column(
  width = 12,
  h2("Rock Gym: British Columbia's finest Gym of Rocks."),
  HTML("<br><br>"),
  h3("Months to Assess:"),
  month_pick_input,
  HTML("<br><br>"),
  fluidRow(
    h2("Program Sign-up"),
    column(width = 6,
           gaugeOutput('program_slots_full_van')
           ),
    column(width = 6,
           gaugeOutput('program_slots_full_vic')
           )
  ),
  fluidRow(
    h2("Membership Growth Goal (%)"),
    column(width = 6, 
           gaugeOutput('membership_goal_van')
           ),
    column(width = 6, 
           gaugeOutput('membership_goal_vic')
    )
  )
)

center_fig_col = column(
  width = 12,
  gross_prof_line_element
)

right_fig_col = column(
  width = 12,
  membership_line_element,
  employee_line_element
)

rock_gym_cfo = tabPanel(
  title = "Rock Gym - CFO Summary",
  icon = icon('coins'),
  fluidRow(
    column(width = 4,
           month_selector_col
    ),
    column(width = 8,
           fluidRow(
             column(width = 6,
                    center_fig_col
             ),
             column(width = 6,
                    right_fig_col
             )
           ),
           fluidRow(
             column(width = 6,
                    van_summary_block
             ),
             column(width = 6,
                    vic_summary_block
             )
           )
    )
  )
)


# rock_gym_cfo = tabPanel(
#   title = "Rock Gym - CFO Summary",
#   icon = icon('coins'),
#   sidebarLayout(
#     sidebarPanel(
#       h2("Rock Gym: British Columbia's finest Gym of Rocks."),
#       HTML("<br><br>"),
#       h3("Months to Assess:"),
#       month_pick_input,
#       width = 3
#     ),
#     mainPanel(
#       width = 9,
#       fluidRow(
#         figs_col_cfo
#       ),
#       summaries_rows
#     )
#   )
