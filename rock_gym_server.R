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
  temp_dat = rock_visit_dat %>%
    filter(location %in% input$visits_location_selector) %>% 
    filter(month %in% input$visits_month_selector) %>% 
    filter(day_of_week %in% input$visits_day_selector) 
  
  if(input$visits_time_scale == "Day"){
    temp_dat = temp_dat %>% 
      group_by(x = hour_of_day) %>% 
      summarise(across(c("visits","drop_ins","members"), mean, na.rm=T))
  } else if(input$visits_time_scale == "Week"){
    temp_dat = temp_dat %>% 
      group_by(x = day_of_week) %>% 
      summarise(across(c("visits","drop_ins","members"), mean, na.rm=T))
  } else if(input$visits_time_scale == "Month"){
    temp_dat = temp_dat %>% 
      group_by(x = month) %>% 
      summarise(across(c("visits","drop_ins","members"), mean, na.rm=T))
  }
  
  temp_dat = temp_dat %>% 
    pivot_longer(c("drop_ins","members"), 
                 names_to = "membership_status", 
                 values_to = visit_number) %>% 
    select(-visits)
  
  if(input$visits_member_filter == "Members"){
    temp_dat %>% 
      filter(membership_status == "members")
  } else if(input$visits_member_filter == "Drop-ins"){
    temp_dat %>% 
      filter(membership_status == "drop_ins")
  } else if(length(input$visits_member_filter) == 2){
    temp_dat
  }
})

## Daily Operations ##
output$rock_visit_barplot = renderPlotly({
  ggplotly(
    rock_visit_dat %>% 
      ggplot() + 
      geom_col(aes(x = x, y = visit_number, fill = membership_status)) + 
      labs(x = "", y =  "Number of Visits")
    
  )
})

## CFO SUMMARY ##

# Summary stats

output$gross_profit_summary_van = renderValueBox({
  valueBox(
    subtitle = h4("Gross Profit"),
    value = tagList(
      h2(
        RockDat() %>%
          filter(location == "Vancouver") %>%
          summarise(gross_profit = sum(gross_profit,na.rm=T)) %>%
          pull(gross_profit) %>% 
          dollar()
      ),
      HTML("<BR>"),
      h4(em(paste0(RockDat() %>%
                     filter(location == "Vancouver") %>%
                     summarise(gross_profit_change = round(100*(last(gross_profit) - first(gross_profit))/last(gross_profit),1)) %>%
                     pull(gross_profit_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))))
    ),
    icon = icon('dollar'),
    color = 'purple'
  )
})

output$revenue_summary_van = renderValueBox({
  valueBox(
    subtitle = h4("Revenue"),
    value = tagList(
      h2(
        RockDat() %>%
          filter(location == "Vancouver") %>%
          summarise(revenue = sum(revenue,na.rm=T)) %>%
          pull(revenue) %>% 
          dollar()
      ),
      HTML("<BR>"),
      h4(em(paste0(RockDat() %>%
                     filter(location == "Vancouver") %>%
                     summarise(revenue_change = round(100*(last(revenue) - first(revenue))/last(revenue),1)) %>%
                     pull(revenue_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))))
    ),
    icon = icon('money-bills'),
    color = 'green'
  )
})

output$cost_summary_van = renderValueBox({
  valueBox(
    subtitle = h4("Cost"),
    value = tagList(
      h2(
        RockDat() %>%
          filter(location == "Vancouver") %>%
          summarise(cost = sum(cost,na.rm=T)) %>%
          pull(cost) %>% 
          dollar()
      ),
      HTML("<BR>"),
      h4(em(paste0(RockDat() %>%
                     filter(location == "Vancouver") %>%
                     summarise(cost_change = round(100*(last(cost) - first(cost))/last(cost),1)) %>%
                     pull(cost_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))))
    ),
    icon = icon('money-bill-wave'),
    color = 'orange'
  )
})

# Victoria summary boxes.
output$gross_profit_summary_vic = renderValueBox({
  valueBox(
    subtitle = h4("Gross Profit"),
    value = tagList(
      h2(
        RockDat() %>%
          filter(location == "Victoria") %>%
          summarise(gross_profit = sum(gross_profit,na.rm=T)) %>%
          pull(gross_profit) %>% 
          dollar()
      ),
      HTML("<BR>"),
      h4(em(paste0(RockDat() %>%
                     filter(location == "Victoria") %>%
                     summarise(gross_profit_change = round(100*(last(gross_profit) - first(gross_profit))/last(gross_profit),1)) %>%
                     pull(gross_profit_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))))
    ),
    icon = icon('dollar'),
    color = 'purple'
  )
})

output$revenue_summary_vic = renderValueBox({
  valueBox(
    subtitle = h4("Revenue"),
    value = tagList(
      h2(
        RockDat() %>%
          filter(location == "Victoria") %>%
          summarise(revenue = sum(revenue,na.rm=T)) %>%
          pull(revenue) %>% 
          dollar()
      ),
      HTML("<BR>"),
      h4(em(paste0(RockDat() %>%
                     filter(location == "Victoria") %>%
                     summarise(revenue_change = round(100*(last(revenue) - first(revenue))/last(revenue),1)) %>%
                     pull(revenue_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))))
    ),
    icon = icon('money-bills'),
    color = 'green'
  )
})

output$cost_summary_vic = renderValueBox({
  valueBox(
    subtitle = h4("Cost"),
    value = tagList(
      h2(
        RockDat() %>%
          filter(location == "Victoria") %>%
          summarise(cost = sum(cost,na.rm=T)) %>%
          pull(cost) %>% 
          dollar()
      ),
      HTML("<BR>"),
      h4(em(paste0(RockDat() %>%
                     filter(location == "Victoria") %>%
                     summarise(cost_change = round(100*(last(cost) - first(cost))/last(cost),1)) %>%
                     pull(cost_change),"%",
                   " change between ",
                   month(min(RockDat()$date),abbr=T,label=T),
                   " - ",
                   month(max(RockDat()$date),abbr=T,label=T))))
    ),
    icon = icon('money-bill-wave'),
    color = 'orange'
  )
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
      scale_fill_brewer(palette = my_palette) +
      scale_color_brewer(palette = my_palette) +
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
    height = 400
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
    height = 400
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
    height = 400
  ) %>% layout(legend = list(orientation="h",x = 0.45, y = 1.1))
})