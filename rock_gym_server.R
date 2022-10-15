# # # # # # # # # #
# Tab 1 - Rock Gym#
# # # # # # # # # #
rock_dat = read_csv("data/rock_dat.csv")
rock_visit_dat = read_csv('data/rock_visit_data.csv')

RockDat = reactive({
  
  #Convert abbreviated month labels to numbers, find total range of months, then relabel them.
  min_month = as_datetime(paste0("2022-",input$months_picked[1],"-01"),"%Y-%b-%d")
  max_month = as_datetime(paste0("2022-",input$months_picked[2],"-01"),"%Y-%b-%d")
  
  rock_dat %>%
    mutate(datetime = as_datetime(as.character(date))) %>% 
    filter(datetime %within% lubridate::interval(min_month,max_month))
})

RockDatSummarised = reactive({
  RockDat() %>% 
    pivot_longer(cols = c("revenue","cost","gross_profit"), 
                 names_to = "Type",values_to = "Amount") %>% 
    mutate(Type = case_when(
      Type == 'revenue' ~ 'Revenue',
      Type == 'cost' ~ 'Cost',
      Type == 'gross_profit' ~ "Gross Profit",
      T ~ Type 
    )) %>% 
    mutate(Type = factor(Type, levels = c("Revenue","Cost","Gross Profit"))) %>% 
    group_by(date,Type) %>% 
    summarise(Amount = sum(Amount))
})

RockVisitDat = reactive({
  
  #Take two days selected and make it into a vector of day names to filter with.
  day_range = c(
    as.numeric(factor(input$visits_day_selector[1],levels = c("Sunday", "Monday", "Tuesday","Wednesday",
                                                   "Thursday", "Friday", "Saturday"))):
    as.numeric(factor(input$visits_day_selector[2],levels = c("Sunday", "Monday", "Tuesday","Wednesday",
                                                   "Thursday", "Friday", "Saturday")))
  ) %>% 
    wday(., abbr=F,label=T,week_start = 7)
  
  #Apply filters that are easy to apply: location, month and day.
  temp_dat = rock_visit_dat %>%
    filter(location %in% input$visits_location_selector) %>% 
    filter(ymd(paste0('2022-',month,'-01')) %within% interval(
      ymd(paste0('2022-',input$visits_month_selector[1],'-01')),
      ymd(paste0('2022-',input$visits_month_selector[2],'-01'))
    )) %>% 
    filter(day_of_week %in% day_range) 
  
  temp_dat = temp_dat %>% 
    select(-visits) %>% 
    pivot_longer(c("drop_ins","members"), 
                 names_to = "membership_status", 
                 values_to = "visits")
  
  #Add a 'none' variable so that facetting doesn't normally do much in the
  # group_by line... If the user chooses to facet by a variable, then this switches
  # from the fake 'none' variable to their facetting variable.
  temp_dat = temp_dat %>% 
    mutate(none = 1)
  
  #Depending on the math mode chosen, average or sum the visits at the time scale.
  if(input$visits_math_mode == "Average"){
    if(input$visits_time_scale == "Day"){
      temp_dat = temp_dat %>% 
        group_by(x = hour_of_day, membership_status, !!sym(input$visits_facet_option)) %>% 
        summarise(visits = mean(visits, na.rm=T)) %>% 
        mutate(x = factor(x, levels = paste0(c(6:22),"H"))) %>% 
        arrange(x)
    } else if(input$visits_time_scale == "Week"){
      temp_dat = temp_dat %>% 
        group_by(x = day_of_week, membership_status, !!sym(input$visits_facet_option)) %>% 
        summarise(visits = mean(visits, na.rm=T)) %>% 
        mutate(x = factor(x, levels = wday(1:7, week_start = 1, label = T, abbr = F))) %>% 
        arrange(x)
    } else if(input$visits_time_scale == "Month"){
      temp_dat = temp_dat %>% 
        group_by(x = month, membership_status, !!sym(input$visits_facet_option)) %>% 
        summarise(visits = mean(visits, na.rm=T)) %>% 
        mutate(x = factor(x, levels = month(1:6, label = T, abbr = T))) %>% 
        arrange(x)
    }
  } else if(input$visits_math_mode == "Sum"){
    if(input$visits_time_scale == "Day"){
      temp_dat = temp_dat %>% 
        group_by(x = hour_of_day, membership_status, !!sym(input$visits_facet_option)) %>% 
        summarise(visits = sum(visits, na.rm=T)) %>% 
        mutate(x = factor(x, levels = paste0(c(6:22),"H"))) %>% 
        arrange(x)
    } else if(input$visits_time_scale == "Week"){
      temp_dat = temp_dat %>% 
        group_by(x = day_of_week, membership_status, !!sym(input$visits_facet_option)) %>% 
        summarise(visits = sum(visits, na.rm=T)) %>% 
        mutate(x = factor(x, levels = wday(1:7, week_start = 1, label = T, abbr = F))) %>% 
        arrange(x)
    } else if(input$visits_time_scale == "Month"){
      temp_dat = temp_dat %>% 
        group_by(x = month, membership_status,!!sym(input$visits_facet_option)) %>% 
        summarise(visits = sum(visits, na.rm=T)) %>% 
        mutate(x = factor(x, levels = month(1:6, label = T, abbr = T))) %>% 
        arrange(x)
    }
  }
  
  #Apply membership filter to data.
  temp_dat = temp_dat %>% 
    mutate(membership_status = case_when(
      membership_status == "drop_ins" ~ "Drop-ins",
      membership_status == "members" ~ "Members"
    )) %>% 
    filter(membership_status %in% input$visits_member_filter) 
  
  # If user chooses to facet by week or month, we have to set factor levels.
  if(!!sym(input$visits_facet_option) == "month"){
    temp_dat = temp_dat %>% 
      mutate(month = factor(month, levels = month(1:6, label = T, abbr = T)))
  } else if(!!sym(input$visits_facet_option) == "day_of_week"){
    temp_dat = temp_dat %>% 
      mutate(day_of_week = factor(day_of_week, levels = wday(1:7, week_start = 1, label = T, abbr = F)))
  }
  
  # Summarise values!
   temp_dat %>%
    group_by(x,membership_status,!!sym(input$visits_facet_option)) %>%
    summarise(visits = sum(visits,na.rm=T))
})

output$data_test = renderDataTable({RockVisitDat()})

## Daily Operations ##
output$rock_visit_barplot = renderPlotly({

  ggplotly(
      RockVisitDat() %>%
        ggplot() + 
        geom_col(aes(x = x, y = visits, fill = membership_status)) + 
        scale_fill_brewer(palette = 'Dark2') +
        facet_wrap(~ .data[[input$visits_facet_option]], 
                     ncol = 1) +
        labs(title = paste0("Visits to Rock Gym by ",input$visits_time_scale),
             x = "", y =  "Number of Visits", fill = "Membership") + 
        theme_bw()
    )
})

# Reset of rock visitation filters.
observeEvent(input$visits_reset_filters, {
updateCheckboxGroupInput(
  session = session,
  inputId = 'visits_member_filter',
    label = "Membership Type",
    choices = c('Members','Drop-ins'),
    selected = c('Members','Drop-ins')
    #size = 'md'
  )
  
  # Location selector
updateCheckboxGroupInput(
  session = session,
  inputId = 'visits_location_selector',
    label = "Location",
    choices = c("Vancouver","Victoria"),
    selected = c("Vancouver","Victoria")
    # size = 'md'
  )
  
  # Day of week selector
updateSliderTextInput(
  session = session,
  inputId = 'visits_day_selector',
    label = 'Days to Include',
    choices = wday(1:7,label=T,abbr=F),
    selected = wday(1:7,label=T,abbr=F)
  )
  
  # month selector
updateSliderTextInput(
  session = session,
  inputId = 'visits_month_selector',
    label = 'Months to Include',
    choices = month(c(1:6),label=T,abbr=T),
    selected = month(c(1:6),label=T,abbr=T)
  )
  
  # Time scale selector
updateSelectInput(
  session = session,
  inputId = 'visits_time_scale',
    label = 'Time Scale',
    choices = c("Day","Week","Month"),
    selected = "Day"
  )
  
  # Change method between average and sum
updateRadioButtons(
  session = session,
  inputId = 'visits_math_mode',
    label = "Method",
    choices = c("Average","Sum"),
    selected = "Average"
  )
  
  # Facet dropdown
updateSelectInput(
  session = session,
    inputId = 'visits_facet_option',
    label = "Split Plot by...",
    choices = c("none","location","month","day_of_week"),
    selected = "none"
  )
})

## CFO SUMMARY ##

# Summary stats

output$gross_profit_sum_van = renderText({
 RockDat() %>%
          filter(location == "Vancouver") %>%
          summarise(gross_profit = sum(gross_profit,na.rm=T)) %>%
          pull(gross_profit) %>% 
          dollar()
})

output$gross_profit_change_van = renderText({
  paste0(RockDat() %>%
           filter(location == "Vancouver") %>%
           summarise(gross_profit_change = round(100*(last(gross_profit) - first(gross_profit))/last(gross_profit),1)) %>%
           pull(gross_profit_change),"%",
         " change between ",
         month(min(RockDat()$date),abbr=T,label=T),
         " - ",
         month(max(RockDat()$date),abbr=T,label=T))
})

output$revenue_sum_van = renderText({
        RockDat() %>%
          filter(location == "Vancouver") %>%
          summarise(revenue = sum(revenue,na.rm=T)) %>%
          pull(revenue) %>% 
          dollar()
})

output$revenue_change_van = renderText({
      paste0(RockDat() %>%
                     filter(location == "Vancouver") %>%
                     summarise(revenue_change = round(100*(last(revenue) - first(revenue))/last(revenue),1)) %>%
                     pull(revenue_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))
})

output$cost_sum_van = renderText({
  RockDat() %>%
          filter(location == "Vancouver") %>%
          summarise(cost = sum(cost,na.rm=T)) %>%
          pull(cost) %>% 
          dollar()
})

output$cost_change_van = renderText({
 paste0(RockDat() %>%
                     filter(location == "Vancouver") %>%
                     summarise(cost_change = round(100*(last(cost) - first(cost))/last(cost),1)) %>%
                     pull(cost_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))
})

# Victoria summary boxes.
output$gross_profit_sum_vic = renderText({
 RockDat() %>%
          filter(location == "Victoria") %>%
          summarise(gross_profit = sum(gross_profit,na.rm=T)) %>%
          pull(gross_profit) %>% 
          dollar()
})

output$gross_profit_change_vic = renderText({
      paste0(RockDat() %>%
                     filter(location == "Victoria") %>%
                     summarise(gross_profit_change = round(100*(last(gross_profit) - first(gross_profit))/last(gross_profit),1)) %>%
                     pull(gross_profit_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))
})

output$revenue_sum_vic = renderText({
  RockDat() %>%
          filter(location == "Victoria") %>%
          summarise(revenue = sum(revenue,na.rm=T)) %>%
          pull(revenue) %>% 
          dollar()
})

output$revenue_change_vic = renderText({
     paste0(RockDat() %>%
                     filter(location == "Victoria") %>%
                     summarise(revenue_change = round(100*(last(revenue) - first(revenue))/last(revenue),1)) %>%
                     pull(revenue_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))
})

output$cost_sum_vic = renderText({
  RockDat() %>%
          filter(location == "Victoria") %>%
          summarise(cost = sum(cost,na.rm=T)) %>%
          pull(cost) %>% 
          dollar()
})

output$cost_change_vic = renderText({
  paste0(RockDat() %>%
                     filter(location == "Victoria") %>%
                     summarise(cost_change = round(100*(last(cost) - first(cost))/last(cost),1)) %>%
                     pull(cost_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))
})

# Plots

max_money_figure = rock_dat %>% 
  group_by(month) %>% 
  summarise(total = sum(revenue)) %>% 
  arrange(desc(total)) %>% 
  slice(1) %>% 
  pull(total)

output$gross_profit_linegraph = renderPlotly({
  plotly::ggplotly(
    
    rock_dat %>%
      # filter(date %within% interval(ymd('2022-02-01'),ymd('2022-05-01')))
      pivot_longer(cols = c("revenue","cost","gross_profit"),
                   names_to = "Type",values_to = "Amount") %>%
      mutate(Type = case_when(
        Type == 'revenue' ~ 'Revenue',
        Type == 'cost' ~ 'Cost',
        Type == 'gross_profit' ~ "Gross Profit",
        T ~ Type
      )) %>%
      mutate(Type = factor(Type, levels = c("Revenue","Cost","Gross Profit"))) %>%
      group_by(date,Type) %>%
      summarise(Amount = sum(Amount)) %>%
      ggplot(aes(x = date, y = Amount)) +
      geom_col(aes(x = date, y = Amount, fill = Type),
               color = 'black',
               position = position_dodge2(padding = 0.3)) +
      geom_line(aes(x = date, y = Amount, col = Type, group = Type),
                alpha = 0.8,
                size = 1) +
      geom_point(aes(x = date, y = Amount, col = Type),
                 shape = 1, size = 4, stroke = 1) +
      geom_segment(aes(x = min(date),
                       xend = max(date),
                       y = -max(Amount)/32,
                       yend = -max(Amount)/32), size = 1,
                   col = "#9fe364",
                   data = RockDatSummarised()) +
      scale_y_continuous(limits = c(-(max_money_figure/32),max_money_figure),
                         labels = scales::dollar_format(scale=0.001,suffix = 'K')) +
      scale_fill_brewer(palette = 'Dark2') +
      scale_color_brewer(palette = 'Dark2') +
      labs(title = 'Gross Profit Breakdown',
           fill = "",
           x = "Month",
           y = "Total ($ CAD)") +
      theme_minimal() +
      theme(axis.title = element_text(size = 12),
            axis.text = element_text(size = 10),
            title = element_text(size = 14, face = 'bold'),
            legend.position="none") +
      guides(col = "none"),
    height = 300
  ) %>% layout(legend = list(orientation="h",x = 0.45, y = 1.1))
})

output$employee_linegraph = renderPlotly({
  ggplotly(
    rock_dat %>% 
      ggplot() + 
      geom_col(aes(x = date, y = employees, fill = location), 
               col = 'black',
               position = position_dodge2(padding = 0.3)) +
      geom_line(aes(x = date, y = employees, col = location, group = location),
                alpha = 0.8,
                size = 1) +
      geom_point(aes(x = date, y = employees, col = location),
                 shape = 1, size = 4, stroke = 1) +
      geom_segment(aes(x = min(date),
                       xend = max(date),
                       y = -max(employees)/32,
                       yend = -max(employees)/32), size = 1,
                   col = "#9fe364",
                   data = RockDat()) +
      scale_y_continuous(limits = c(-max(rock_dat$employees)/32,max(rock_dat$employees))) + 
      scale_fill_brewer(palette = 'Set2') +
      scale_color_brewer(palette = 'Set2') +
      labs(title = 'Employees',
           fill = "Location",
           x = "Month", 
           y = "No. Employees") + 
      theme_minimal() + 
      theme(axis.title = element_text(size = 12),
            axis.text = element_text(size = 10),
            title = element_text(size = 14, face = 'bold'),
            legend.position="none") + 
      guides(col = "none"),
    height = 300
  ) %>% layout(legend = list(orientation="h",x = 0.45, y = 1.1))
})

output$members_linegraph = renderPlotly({
  ggplotly(
    rock_dat %>% 
      ggplot(aes(x = date, y = members)) + 
      geom_col(aes(fill = location), 
               color = 'black',
               position = position_dodge2(padding = 0.3)) +
      geom_line(aes(col = location, group = location),
                alpha = 0.8,
                size = 1) +
      geom_point(aes(x = date, y = members, col = location), 
                 shape = 1, size = 4, stroke = 1) +
      geom_segment(aes(x = min(date),
                       xend = max(date),
                       y = -max(members)/32,
                       yend = -max(members)/32), size = 1,
                   col = "#9fe364",
                   data = RockDat()) +
      scale_y_continuous(limits = c(-max(rock_dat$members)/32,max(rock_dat$members))) + 
      scale_fill_brewer(palette = 'Set2') +
      scale_color_brewer(palette = 'Set2') +
      labs(title = 'Membership',
           fill = "Location",
           x = "Month", 
           y = "No. of Members") + 
      theme_minimal() + 
      theme(axis.title = element_text(size = 12),
            axis.text = element_text(size = 10),
            title = element_text(size = 14, face = 'bold'),
            legend.position="none") + 
      guides(col = "none"),
    height = 300
  ) %>% layout(legend = list(orientation="h",x = 0.45, y = 1.1))
})