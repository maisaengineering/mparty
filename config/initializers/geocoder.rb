 # Geocoder.configure(
 #    # geocoding options
 #    timeout:       40  ,  #      # geocoding service timeout (secs)
 #    ip_lookup:     :maxmind_local, # http://dev.maxmind.com/geoip/legacy/geolite/
 #    maxmind_local: {file: Rails.root.join("lib/geolitedb/GeoLiteCity.dat")} 
 #   )

GEOIP = GeoIP.new('lib/geolitedb/GeoLiteCity.dat')