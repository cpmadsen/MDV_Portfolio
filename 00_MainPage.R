background_img_1 = "carousel_pictures/Germany_Dresden_ForestCenterTown.png"
background_img_2 = "carousel_pictures/river_view.png"
background_img_3 = "carousel_pictures/Germany_BlackForest.png"

title_insert = absolutePanel(
  fluidRow(
    h1("MADSEN DATA VISUALIZATIONS",
       style = 'height: 50px; font-size:65px; color:white; text-align:center;padding:80px'),
    HTML("<br><br>"),
    h2("STATE-OF-THE-ART DATA ANALYTICS AND DASHBOARDS",
       style = 'height: 50px; font-size:50px; color:white; text-align:center;padding:80px;'),
    width = '100%'),
  style = 'margin-left:100px;'
)

second_insert = fluidRow(
  h1("Explore your Data to Make Informed Decisions",
     style = 'text-align:center;center;padding:60px'),
  HTML("<br><br><br><br>"),
  h2("Data records can be opaque or confusing; however, I can help make your data transparent and highlight important trends and decision points.",
     style = 'text-align:center;margin:30px'),
  HTML("<br>"),
  h2("With over 6 years of experience analysing and visualizing tabular and spatial datasets, I've learned efficient workflows for producing meaningful figures and reports.",
     style = 'text-align:center;margin:30px'),
  HTML("<br>"),
  h2("Best of all, informative dashboards don't have to break the bank - explore the example dashboards in my portfolio to see what can be produced in 5 - 20 hours of work.",
     style = 'text-align:center;margin:30px'),
  box(solidHeader = FALSE,
      title = h1("Services Include",
                 style = 'text-align:center;margin-top:-10px'),
      background = NULL,
      width = 12,
      status = "danger",
      fluidRow(
        column(width = 4,
               # shiny::icon(name = "database", style = 'font-size:75px;'),
               img(src = 'mop_icon2.png'),
               h3("Data Cleaning and Analysis"),
               style = 'text-align:center; font-size:1px;'),
        column(width = 4,
               # shiny::icon(name = "chart-line", style = 'font-size:75px;'),
               img(src = 'map_icon.png'),
               h3("Visualizations and Maps"),
               style = 'text-align:center;font-size:1px;'),
        column(width = 4,
               # shiny::icon(name = "tachometer-alt", style = 'font-size:75px;'),
               img(src = 'dashboard_icon.png'),
               h3("Bespoke dashboards"),
               style = 'text-align:center;font-size:1px;'),
        HTML("<br><br><br>")
      )
  ),
  style = 'padding-left:100px; padding-right:100px'
)

third_insert = fluidRow(
  h1("Qualifications",style = 'text-align:center;center;padding:60px'),
  column(width = 4,
         img(src = "CM_Headshot.png")),
  column(width = 8,
         h2("Professional",style = 'font-weight:bold;center;padding:20px'),
         h3(tagList(icon('arrow-right'),"2 years as Data Visualization Specialist and GIS analyst with the British Columbian Provincial Government")),
         h3(tagList(icon('arrow-right'),"6 months as Forest Restoration Scientist with Parks Canada")),
         HTML("<br>"),
         h2("Educational",style = 'font-weight:bold;center;padding:20px'),
         h3(tagList(icon('arrow-right'),"2019 Master of Science in Biology from McGill University")),
         h3(tagList(icon('arrow-right'),"2015 Honours Undergraduate Degree in Biology from the University of Victoria")),
         style = 'text-align:left;')
)

contact_form_insert = fluidRow(
  mailtoR(email = "madsen.chris26@gmail.com",
          text = "Contact by E-mail"),
  use_mailtoR(),
  style = 'text-align:center;center;padding:40px;font-size:30px;'
)
# contact_form_insert = fluidRow(
#   h1("Contact Form", style = 'text-align:center;center;padding:40px'),
#   textInput(
#     inputId = 'user_contact_email',
#     label = "Your E-mail Address:",
#     placeholder = "your.name@gmail.com"
#   ),
#   textInput(
#     inputId = 'email_subject_line',
#     label = 'Subject Line:',
#     placeholder = 'Write subject line here...'
#   ),
#   textInput(inputId = "email_body", 
#             label = "Message Body",
#             value=""),
#   actionBttn(inputId = "send_email", label = "Send email", icon = icon('email'))
# ) 
# backgroundImageCSS <- "/* background-color: #cccccc; */
#                        height: 91vh;
#                        background-position: center;
#                        background-repeat: no-repeat;
#                        /* background-size: cover; */
#                        background-image: url('%s');
#                        "

main_page = tabPanel(
  title = "Home",
  icon = icon('fas fa-house'),
  
  #tags$script(src = "Javascript_Parallax.js"),
  # shinyWidgets::setBackgroundImage(src = "waterfall_gif.gif", 
  #                                  shinydashboard = T),
  
  # absolutePanel(
  # h2("Chris Madsen Dashboard Portfolio",
  #    tags$style('height: 100px; width: 100%; text-align:center; font-size: 50px')
  # )
  # ),
  
  title_insert,
  
  parallax_image(background_img_1),
  
  second_insert,
  
  parallax_image(background_img_2, background_number = 2),
  
  # fluidRow(p(""),
  #               style = 'height:200px;'),
  
  third_insert,
  
  parallax_image(background_img_3, background_number = 3),
  
  contact_form_insert
)