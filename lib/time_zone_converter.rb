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

  def self.call(args, time, method = :utc)
    arr = Array.new

    if method == :utc
      time = string_to_time(time, "UTC")
      arr = args.map { |city| [city, get_time(city, time)] }
    else # :local
      # Get time with zone for the first city
      time_zone = get_nearest_time_zone(args.first)

      if time.nil?
        time = Time.current.in_time_zone(time_zone)
      else
        time = string_to_time(time, time_zone)
      end

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
      json = Oj.load(File.read(File.join(File.dirname(__FILE__), "../#{JSON_FILE}")))
      item = json.select! { |k, _| k == city }
      raise "Not found #{city}" unless item

      lat, lng = item[city][0], item[city][1]
      time_zone = NearestTimeZone.to(lat.to_f, lng.to_f)
    end

    # time is a Time object or an Array of Time objects
    def self.get_time(city, time)
      time_zone = get_nearest_time_zone(city)
      if time.is_a? Array
        time.map { |t| t.in_time_zone(time_zone) }
      else
        time.in_time_zone(time_zone)
      end
    end

    ISO_TIME = /\A(\d?\d):(\d\d)\z/
    ISO_TIME_RANGE = /\A(\d?\d):(\d\d)-(\d?\d):(\d\d)\z/

    # Inspired by: https://github.com/rails/rails/blob/aeba121a83965d242ed6d7fd46e9c166079a3230/activemodel/lib/active_model/type/helpers/time_value.rb#L65
    # @returns: Time object or an Array of Time objects
    def self.string_to_time(time, time_zone)
      return time unless time.is_a? String
      current_time = Time.new.utc
      zone = ActiveSupport::TimeZone[time_zone]

      if time =~ ISO_TIME
        new_time(current_time.year, current_time.month, current_time.day, $1.to_i, $2.to_i, 0, 0, zone)
      elsif time =~ ISO_TIME_RANGE
        [
          new_time(current_time.year, current_time.month, current_time.day, $1.to_i, $2.to_i, 0, 0, zone),
          new_time(current_time.year, current_time.month, current_time.day, $3.to_i, $4.to_i, 0, 0, zone)
        ]
      end
    end

    def self.new_time(year, mon, mday, hour, min, sec, microsec, zone)
      Time.new(
        year,
        mon,
        mday,
        hour,
        min,
        sec,
        zone
      )
    end
end
