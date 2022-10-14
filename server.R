rm(list=ls())
#setwd("F:/R Projects/cpmadsen.github.io")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  source(file.path('rock_gym_server.R'), local = T)$value
  source(file.path('bigfoot_server.R'), local = T)$value
  source(file.path('uk_cycling_server.R'), local = T)$value

  
  # Light- and Dark-theme switcher
  observeEvent(input$dark_mode, {
    if(input$dark_mode == T) {
      session$setCurrentTheme(app_darkTheme)
    } else if(input$dark_mode == F){
      session$setCurrentTheme(app_lightTheme)
    }
  })
  
  #options(httr_oob_default = TRUE, httr_oauth_cache=TRUE)
  
  #gmailr::clear_token()
  # gmailr::gm_auth_configure(path = 'www/client_secret_for_MDV_Portfolio.json')
  # gmailr::gm_auth(
  #   email = "cpmadsenviking@gmail.com",
  #   path = 'www/client_secret_for_MDV_Portfolio.json'
  # )
  
  # # Email sending function.
  # observeEvent(input$send_email, {
  #   if(is.null(input$send_email) || input$send_email==0) return(NULL)
  #   from <- input$user_contact_email
  #   to <- 'cpmadsenviking@gmail.com'
  #   subject <- input$email_subject_line
  #   msg <- input$email_body
  # })
})