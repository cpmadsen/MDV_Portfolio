text_insert = fluidRow(
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

about_me_panel = tabPanel(
  title = "About Me",
  icon = icon('fas scroll'),
  
  text_insert,
  
  contact_form_insert
)