require "time_zone_converter/version"
require "time_zone_converter/json_data_transformer"
require "time_zone_converter/cli"
require 'active_support/core_ext/time'
require "nearest_time_zone"

module TimeZoneConverter
  class Error < StandardError; end

  # Inspired by:
  # https://stackoverflow.com/questions/8349817/ruby-gem-for-finding-timezone-of-location

  def self.call(args, time = Time.current)
    time = get_time_from_string(time) if time.is_a? String
    args.map { |city| [city, get_time(city, time)] }
  end

  private

    def self.get_time(city, time)
      json_file = 'data/cities.json'
      json = JSON.parse(File.read(json_file))
      item = json.select { |k, _| k == city }

      raise "Not found #{city}" unless item

      lat = item[city][0]
      lng = item[city][1]

      time_zone = NearestTimeZone.to(lat.to_f, lng.to_f)
      time = time.in_time_zone(time_zone)
    end

    def self.get_time_from_string(time)
      hh = time.split(":").first.to_i
      mm = time.split(":").last.to_i
      offset = 0

      Time.new(
        Time.current.year,
        Time.current.month,
        Time.current.day,
        hh,
        mm,
        0,
        offset
      )
    end

end
