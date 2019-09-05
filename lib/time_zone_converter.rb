require "time_zone_converter/version"
require "time_zone_converter/json_data_transformer"
require "time_zone_converter/cli"
require 'active_support/core_ext/time'
require "nearest_time_zone"

module TimeZoneConverter
  class Error < StandardError; end

  # Inspired by:
  # https://stackoverflow.com/questions/8349817/ruby-gem-for-finding-timezone-of-location

  def self.call(args)
    args.map { |city| [city, get_time(city)] }
  end

  private

    def self.get_time(city, time = Time.now)
      json_file = 'data/cities.json'
      json = JSON.parse(File.read(json_file))
      item = json.select { |k, _| k == city }

      raise "Not found #{city}" unless item

      lat = item[city][0]
      lng = item[city][1]

      time_zone = NearestTimeZone.to(lat.to_f, lng.to_f)
      time = time.in_time_zone(time_zone)
    end
end
