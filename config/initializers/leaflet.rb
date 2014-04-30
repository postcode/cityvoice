if ENV['MAPBOX_MAP_ID'].present?
  Leaflet.tile_layer = "http://api.tiles.mapbox.com/v3/#{ENV['MAPBOX_MAP_ID']}/{z}/{x}/{y}.png"
  Leaflet.attribution = '<a href="https://www.mapbox.com/about/maps/" target="_blank">&copy;Mapbox &copy;OpenStreetMap</a> | <a class="mapbox-improve-map" href="https://www.mapbox.com/map-feedback/" target="_blank">Improve this map</a>'
else
  Leaflet.tile_layer = 'http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png'
  Leaflet.attribution = 'Tiles courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a>'
end

Leaflet.max_zoom = 12
