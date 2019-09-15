require "time_zone_converter/version"
require "time_zone_converter/json_data_transformer"
require "time_zone_converter/cli"
require 'active_support/core_ext/time'
require "nearest_time_zone"
require 'oj'
require 'byebug'

module TimeZoneConverter
  class Error < StandardError; end

  # Inspired by:
  # https://stackoverflow.com/questions/8349817/ruby-gem-for-finding-timezone-of-location

  def self.call(args, time = Time.current, method = :utc)
    arr = Array.new

    if method == :utc
      time = string_to_time(time, "UTC")
      arr = args.map { |city| [city, get_time(city, time)] }
    else # :local
      # Get time with zone for the first city
      time_zone = get_nearest_time_zone(args.first)
      time = string_to_time(time, time_zone)

      # Add first item
      arr << [args.first, time]

      # Convert time for the rest of the cities in the args
      args[1..-1].each { |city| arr << [city, get_time(city, time)] }
      arr
    end
  end

  private

    JSON_FILE = 'data/cities.json'

    def self.get_nearest_time_zone(city)
      json = Oj.load(File.read(JSON_FILE))
      item = json.select! { |k, _| k == city }
      raise "Not found #{city}" unless item

      lat, lng = item[city][0], item[city][1]
      time_zone = NearestTimeZone.to(lat.to_f, lng.to_f)
    end

    def self.get_time(city, time)
      time_zone = get_nearest_time_zone(city)
      time.in_time_zone(time_zone)
    end

    ISO_TIME = /\A(\d\d):(\d\d)\z/

    def self.string_to_time(string, time_zone)
      return unless string.is_a? String

      if string =~ ISO_TIME
        zone = ActiveSupport::TimeZone[time_zone]
        current_time = Time.new.utc

        Time.new(
          current_time.year,
          current_time.month,
          current_time.day,
          $1.to_i,
          $2.to_i,
          0,
          zone
        )
      end
    end
end
