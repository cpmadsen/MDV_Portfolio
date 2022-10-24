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
     style = 'text-align:center;center;padding-top:60px'),
  box(solidHeader = FALSE,
      background = NULL,
      width = 12,
      status = "danger",
      fluidRow(
        column(width = 4,
               img(src = 'mop_icon2.png'),
               h3("Data Cleaning and Analysis"),
               style = 'text-align:center; font-size:1px;'),
        column(width = 4,
               img(src = 'map_icon.png'),
               h3("Visualizations and Maps"),
               style = 'text-align:center;font-size:1px;'),
        column(width = 4,
               img(src = 'dashboard_icon.png'),
               h3("Bespoke dashboards"),
               style = 'text-align:center;font-size:1px;'),
        style = 'padding:60px;'
      )
  ),
  HTML("<br><br><br><br>"),
  style = 'padding-left:100px; padding-right:100px'
)

third_insert = fluidRow(
  h2("Data records can be opaque or confusing; however, I can help make your data transparent and highlight important trends and decision points.",
     style = 'text-align:center;margin:30px;padding-top:30px'),
  HTML("<br>"),
  h2("With over 6 years of experience analysing and visualizing tabular and spatial datasets, I've learned efficient workflows for producing meaningful figures and reports.",
     style = 'text-align:center;margin:30px;'),
  HTML("<br>"),
  h2("Best of all, informative dashboards don't have to break the bank - explore the example dashboards in my portfolio to see what can be produced in 5 - 20 hours of work.",
     style = 'text-align:center;margin:30px;padding-bottom:30px')
)

main_page = tabPanel(
  title = "Home",
  icon = icon('fas fa-house'),
  
  title_insert,
  
  parallax_image(background_img_1),
  
  second_insert,
  
  parallax_image(background_img_2, background_number = 2),
  
  third_insert,
  
  parallax_image(background_img_3, background_number = 3)
  
)