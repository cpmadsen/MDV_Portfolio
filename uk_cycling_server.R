# CYCLING IN THE UK #
uk_cyclingaccs = read_sf("data/cyclingUK/uk_cyclingaccidents.gpkg")
uk_cyclingacc_outcomes = readxl::read_excel('data/cyclingUK/cycling_accident_outcome_summaries.xlsx')

CyclePal = reactive({
  colorNumeric(palette = 'Spectral',
               domain = CyclingAccidents()$num_accidents,
               reverse = T)
})

CyclingAccidents = reactive({
  uk_cyclingaccs %>%
    st_drop_geometry() %>% 
    filter(year == input$uk_cycling_year)
})

CyclingAccidents_polys = reactive({
  uk_cyclingaccs %>%
    filter(year == input$uk_cycling_year)
})

CyclingAccidentSummaries = reactive({
  uk_cyclingacc_outcomes %>% 
    filter(year == input$uk_cycling_year)
})

CyclingAccidentLinePlotDat = reactive({
  uk_cyclingaccs %>% 
    st_drop_geometry() %>% 
    filter(region %in% all_of(
      uk_cyclingaccs %>%
        st_drop_geometry() %>% 
        group_by(region) %>% 
        summarise(total_accidents = sum(num_accidents,na.rm=T)) %>% 
        arrange(desc(total_accidents)) %>% 
        slice(1:as.numeric(input$number_lines)) %>% 
        pull(region)))
})
# Summary info boxes.
output$uk_fatal_accidents = renderText({
  CyclingAccidentSummaries() %>% 
    filter(CycleAccOutcome == "Killed") %>% 
    pull(num_accidents)
})

output$uk_serious_accidents = renderText({
  CyclingAccidentSummaries() %>% 
    filter(CycleAccOutcome == "Seriously injured") %>% 
    pull(num_accidents)
})

output$uk_total_accidents = renderText({
  CyclingAccidentSummaries() %>% 
    filter(CycleAccOutcome == "Total") %>% 
    pull(num_accidents)
})

output$uk_tot_proj = renderText({
  CyclingAccidents() %>% 
    summarise(total = sum(total_projects_by_region, na.rm=T)) %>% 
    pull(total)
})

output$uk_tot_scheme_cost = renderText({
  scales::dollar(CyclingAccidents() %>% 
                   summarise(total = sum(annual_total_schemes_cost, na.rm=T)) %>% 
                   pull(total),
                 prefix=enc2utf8("\u00A3"))
})

output$uk_tot_df_t_funding = renderText({
  scales::dollar(CyclingAccidents() %>% 
                   summarise(total = sum(annual_df_t_funding, na.rm=T)) %>% 
                   pull(total),
                 prefix=enc2utf8("\u00A3"))
})

output$uk_cycling_leaflet = renderLeaflet({
  leaflet() %>%
    addProviderTiles("Esri.WorldImagery",
                     group = "Satellite",
                     options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
    addProviderTiles("OpenStreetMap",
                     group = "OSM",
                     options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
    addScaleBar(position = "bottomright") %>%
    addPolygons(data = uk_cyclingaccs %>% filter(year == 2005),
                label = ~paste0(region,": ",num_accidents, " accidents"),
                fillColor = ~CyclePal()(num_accidents),
                color = "black",
                fillOpacity = 0.5) %>% 
    addLegend(pal = CyclePal(),
              values = uk_cyclingaccs %>% filter(year == 2005) %>% pull(num_accidents)) %>% 
    leaflet.extras::addResetMapButton() %>%
    hideGroup(c("Satellite")) %>%
    addLayersControl(baseGroups = c("OSM","Satellite"),
                     options = layersControlOptions(collapsed = F))
})

observe({
  leafletProxy('uk_cycling_leaflet') %>%
    clearShapes() %>%
    addPolygons(data = CyclingAccidents_polys(),
                label = ~paste0(region,": ",num_accidents, " accidents"),
                fillColor = ~CyclePal()(num_accidents),
                color = "black",
                fillOpacity = 0.5)
})

# UK cycling line graph
output$cycling_lineplot = renderPlotly({
  ggplotly(
    CyclingAccidentLinePlotDat() %>% 
      #mutate(year = factor(year, levels = c(2005:2016))) %>% 
      ggplot(aes(x = year, y = num_accidents, col = region, group = region)) + 
      geom_vline(data = CyclingAccidents(),
                 aes(xintercept = year),
                 lty = 2
      ) +
      geom_line(se = F, size = 2, alpha = 0.5) + 
      scale_x_continuous(breaks = scales::pretty_breaks()) +
      scale_fill_brewer(palette = 'Set3') +
      ggpubr::theme_pubr() + 
      theme(legend.position = 'none',
            axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
            # plot.background = element_rect(fill = plot_background_colour),
            # panel.background = element_rect(fill = plot_background_colour)) + 
      labs(y = "No. Accidents per Region", 
           x = "Year"),
    tooltip = c("region","num_accidents")
  ) 
})

# # UK cycling line graph
# output$cycling_lineplot = renderPlot({
#   CyclingAccidentLinePlotDat() %>% 
#     ggplot(aes(x = year, y = num_accidents, col = region, group = region)) + 
#     geom_vline(data = CyclingAccidents(),
#                aes(xintercept = year)) +
#     geom_smooth(se = F, size = 2, alpha = 0.5) + 
#     scale_x_discrete() +
#     ggpubr::theme_pubr() + 
#     theme(legend.position = 'bottom') + 
#     labs(y = "Number of Accidents by Region", 
#          x = "Year")
# })
# UK cycling accidents by region.

output$cycling_acc_region_barplot = renderPlotly({
  ggplotly(
    CyclingAccidents() %>% 
      ggplot() + 
      geom_col(aes(x = reorder(region,desc(num_accidents)), y = num_accidents, fill = region)) + 
      scale_fill_brewer(palette = 'Set3') +
      ggpubr::theme_pubr() + 
      theme(legend.position = 'none') + 
      theme(axis.text.x = element_blank(),
            axis.title = element_text(size = 14)) +
            # plot.background = element_rect(fill = plot_background_colour),
            # panel.background = element_rect(fill = plot_background_colour)) +
      labs(y = "No. Accidents per Region", 
           x = "Region"),
    tooltip = c("region","num_accidents")
  )
})

# output$cycling_acc_region_donut = renderPlotly({
#   plot_ly() %>% 
#     add_pie(data = CyclingAccidents(), 
#             labels = ~region, 
#             values = ~num_accidents,
#             hole = 0.6) %>% 
#     layout(showlegend = F,
#            yaxis = list(showgrid=F,zeroline=F,showticklabels=F),
#            xaxis = list(showgrid=F,zeroline=F,showticklabels=F)) %>% 
#     plotly::add_text(data = CyclingAccidents(),
#                      x = 0,
#                      y = 0,
#                      size = 3,
#                      text = ~paste0("Total\n",sum(num_accidents)))
# })