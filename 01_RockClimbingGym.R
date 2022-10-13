### Static Options

my_palette = "Dark2"
box_height = 400

### Elements

# 1. Month selector
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

# 2. Membership line graph
membership_line_element = plotlyOutput('members_linegraph', height = 400)

# 3. Employee line graph
employee_line_element = plotlyOutput('employee_linegraph', height = 400)

# 4. Gross Profit Breakdown Line Graph
gross_prof_line_element = plotlyOutput('gross_profit_linegraph', height = 400)

# # Vancouver summary elements
# gross_profit_summary_element_van = div(
#   valueBoxOutput('gross_profit_summary_van',width = '100%'))
# gross_profit_change_summary_element_van = div(
#   valueBoxOutput('gross_profit_change_summary_van', width = '100%'))
# revenue_summary_element_van = div(
#   valueBoxOutput('revenue_summary_van',width = '100%'))
# revenue_change_summary_element_van = div(
#   valueBoxOutput('revenue_change_summary_van', width = '100%'))
# cost_summary_element_van = div(
#   valueBoxOutput('cost_summary_van',width = '100%'))
# cost_change_summary_element_van = div(
#   valueBoxOutput('cost_change_summary_van', width = '100%'))
# 
# # Victoria Summary elements
# gross_profit_summary_element_vic = div(
#   valueBoxOutput('gross_profit_summary_vic',width = '100%'))
# gross_profit_change_summary_element_vic = div(
#   valueBoxOutput('gross_profit_change_summary_vic', width = '100%'))
# revenue_summary_element_vic = div(
#   valueBoxOutput('revenue_summary_vic',width = '100%'))
# revenue_change_summary_element_vic = div(
#   valueBoxOutput('revenue_change_summary_vic', width = '100%'))
# cost_summary_element_vic = div(
#   valueBoxOutput('cost_summary_vic',width = '100%'))
# cost_change_summary_element_vic = div(
#   valueBoxOutput('cost_change_summary_vic', width = '100%'))

### Design Blocks

top_row = fluidRow(
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

rock_gym = tabItem(
  tabName = "rock_gym",
  h2("Rock Gym CFO Dashboard (Q1 and Q2, 2022)"),
  box(title = "Select Months to Compare", month_pick_input, width = 12,
      collapsible = T, collapsed = T),
  top_row
)

# top_row = fluidRow(
#   column(width = 4,
#          h2("Summary Widgets"),
#          fluidRow(
#            column(width = 6,
#                   box(title = "Vancouver",
#                       revenue_summary_element_van,
#                       revenue_change_summary_element_van,
#                       width = 12, height = box_height)),
#            column(width = 6,
#                   box(title = "Victoria",
#                        revenue_summary_element_vic,
#                        revenue_change_summary_element_vic,
#                        width = 12, height = box_height))),
#          style = '{padding-left:5px;padding-right:5px;}'
#   ),
#   column(width = 8,
#          h2("Figures"),
#          box(gross_prof_line_element, width = 12, height = box_height,
#              style = '.box-header.with-border{display:none}')
#   )
# )

#'.box-header.with-border{display:none}'
# Was from style of box
# width = 12, 
# height = box_height,
# style = 'text-size:20px'
# #tags$style(HTML('height:300px;'))

# middle_row = fluidRow(
#   column(width = 4,
#          fluidRow(
#            column(width = 6,
#                   box(title = "Vancouver",
#                       cost_summary_element_van,
#                       cost_change_summary_element_van,
#                       width = 12, height = box_height)),
#            column(width = 6,
#                   box(title = "Victoria",
#                       cost_summary_element_vic,
#                       cost_change_summary_element_vic,
#                       width = 12, height = box_height)))
#   ),
#   column(width = 8,
#          box(membership_line_element, width = 12, height = box_height,
#              style = '.box-header.with-border{display:none}')
#   )
# )
# 
# bottom_row = fluidRow(
#   column(width = 4,
#          fluidRow(
#            column(width = 6,
#                   box(title = "Vancouver",
#                       gross_profit_summary_element_van,
#                       gross_profit_change_summary_element_van,
#                       width = 12, height = box_height),
#                   style = '.class="col-sm-6" {padding-right:0px;padding-left:0px}'),
#            column(width = 6,
#                   box(title = "Victoria",
#                       gross_profit_summary_element_vic,
#                       gross_profit_change_summary_element_vic,
#                       width = 12, height = box_height)))
#   ),
#   column(width = 8,
#          box(employee_line_element, width = 12, height = box_height,
#              style = '.box-header.with-border{display:none}')
#   )
# )

# rock_gym = tabItem(
#   tabName = "rock_gym",
#   h2("Rock Gym CFO Dashboard (Q1 and Q2, 2022)"),
#   box(title = "Month to Compare", month_pick_input, width = 12,
#       collapsible = T, collapsed = T),
#   top_row,
#   middle_row,
#   bottom_row
# )