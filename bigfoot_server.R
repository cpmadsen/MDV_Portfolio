# # # # # # # # # # 
# Tab 2 - Bigfoot #
# # # # # # # # # # 

bigfoot_dat = read_sf("data/bigfoot_dat.gpkg")
map_centroids = read_csv("data/map_centroids.csv")

#Make custom bigfoot icon
bigfoot_icon = makeIcon("bigfoot_silhouette.png", iconWidth = 24, iconHeight = 30)

#If user has filtered Dat(), apply and make MappingDat()
MappingDat = reactive({
  bigfoot_dat %>% 
    mutate(Year = year(most_recent_report)) %>% 
    filter(unit %in% input$bigfoot_filter) %>% 
    filter(Year >= input$bigfoot_daterange[1],
           Year <= input$bigfoot_daterange[2])
})

MappingCoords = reactive({
  map_centroids %>% 
    filter(region %in% input$bigfoot_filter)
})

Bigfoot_Location = reactive({
  MappingDat() %>% 
    slice_max(most_recent_report) %>% 
    st_centroid()
})
MyPal = reactive({
  # if(input$bigfoot_plotvar == "Number of reports"){
  colorNumeric(palette = "Spectral",
               domain = MappingDat()$num_listings,
               reverse = T)
  # } 
  # else if(input$bigfoot_plotvar == "Date of most recent report"){
  #   colorBin(palette = "Spectral",
  #                domain = year(MappingDat()$most_recent_report),
  #                reverse = T)
  # }
})

output$bigfoot_map = renderLeaflet({
  leaflet() %>% 
    addProviderTiles("Esri.WorldImagery",
                     group = "Satellite",
                     options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
    addProviderTiles("OpenStreetMap",
                     group = "OSM",
                     options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
    addScaleBar(position = "bottomright") %>%
    leaflet.extras::addResetMapButton() %>%
    hideGroup(c("Satellite")) %>% 
    setView(lat = 55.4, lng =  -93.3, zoom = 3) %>%
    addPolygons(data = bigfoot_dat %>% filter(unit == "Canada"),
                label = ~paste0(subunit,",",
                                num_listings,
                                " sightings of ",local_name,", most recent: ",
                                most_recent_report),
                color = ~MyPal()(num_listings)
    ) %>%
    addMarkers(data = Bigfoot_Location(),
               icon = bigfoot_icon,
               group = "Most Recent Report") %>% 
    addLegend(position = "bottomleft",
              pal = MyPal(),
              values = MappingDat()$num_listings,
              layerId = "temp_legend") %>%
    addLayersControl(baseGroups = c("OSM","Satellite"),
                     overlayGroups = c("Most Recent Report"),
                     options = layersControlOptions(collapsed = F),
                     position = "bottomleft")
})

#Reactively populate the map with polygons (or buffered points)
# that map users have added.
observe({
  
  leafletProxy("bigfoot_map") %>% 
    clearShapes() %>% 
    removeControl(layerId = "temp_legend") %>% 
    addPolygons(data = MappingDat(),
                label = ~paste0(subunit,", ",
                                num_listings,
                                " sightings of ",local_name,", most recent: ",
                                most_recent_report),
                color = ~MyPal()(num_listings)) %>% 
    addMarkers(data = Bigfoot_Location(),
               icon = bigfoot_icon) %>% 
    addLegend(pal = MyPal(),
              values = MappingDat()$num_listings) %>% 
    setView(lng = MappingCoords()$X,
            lat = MappingCoords()$Y,
            zoom = MappingCoords()$zoom)
})

output$bigfoot_barplot = renderPlotly({
  
  plotly::ggplotly(
    MappingDat() %>% 
      st_drop_geometry() %>% 
      mutate(subunit = fct_reorder(subunit,num_listings,.desc=T)) %>% 
      mutate(subunit = fct_lump(subunit, input$binning_number, w = num_listings)) %>% 
      group_by(subunit) %>% 
      summarise(most_recent_report = max(most_recent_report),
                num_listings = sum(num_listings)) %>% 
      ggplot() + 
      geom_col(aes(x = subunit, y = num_listings, fill = num_listings)) + 
      scale_x_discrete(labels = scales::label_wrap(width = 8)) + 
      coord_flip() +
      scale_fill_continuous("viridis") +
      labs(x = "", y = "Number of Reports", title = "Reports by Region") +
      ggpubr::theme_pubr() + 
      theme(legend.position = "none")
            # plot.background = element_rect(fill = plot_background_colour),
            # panel.background = element_rect(fill = plot_background_colour))
  )
})

output$total_summary = renderText({
    MappingDat() %>%
      st_drop_geometry() %>%
      summarise(total = sum(num_listings)) %>%
      pull(total)
})

output$most_recent_date = renderText({
    MappingDat() %>% 
      st_drop_geometry() %>% 
      mutate(most_recent_report = lubridate::ymd(most_recent_report)) %>% 
      summarise(latest = max(most_recent_report)) %>% 
      pull(latest)
})

output$most_recent_place = renderText({
    MappingDat() %>% 
      st_drop_geometry() %>% 
      arrange(desc(most_recent_report)) %>% 
      slice(1) %>% 
      pull(subunit)
})

#News feed - slickR carousel
output$bigfoot_news_table = renderDataTable({
  myquery <- feed.extract("https://news.google.com/rss/search?q=Bigfoot")
  myquery$items %>% 
    as_tibble() %>% 
    select(title,date,link) %>% 
    rename(Title = title, Date = date, Link = link) %>% 
    mutate(Date = str_extract(as.character(Date),".*(?= )")) %>% 
    DT::datatable(., options = list(lengthMenu = c(3, 5, 10), pageLength = 3))
})