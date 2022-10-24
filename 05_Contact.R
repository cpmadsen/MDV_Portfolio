contact_panel = tabPanel(
  title = "Contact",
  icon = icon('envelope'),
  fluidRow(
    h3("Contact Links",
       style = 'text-align;center;'),
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
