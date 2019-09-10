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

  def self.call(args, time = Time.current, method)
    if method == :local
      time_zone = get_zone(args.first)
    end

    time = string_to_time(time, method, time_zone) if time.is_a? String
    args.map { |city| [city, get_time(city, time)] }
  end

  private

    def self.get_time(city, time)
      json_file = 'data/cities.json'
      json = Oj.load(File.read(json_file))
      item = json.select! { |k, _| k == city }

      raise "Not found #{city}" unless item

      lat = item[city][0]
      lng = item[city][1]

      time_zone = NearestTimeZone.to(lat.to_f, lng.to_f)
      time = time.in_time_zone(time_zone)
    end

    def self.get_zone(city)
      json_file = 'data/cities.json'
      json = Oj.load(File.read(json_file))
      item = json.select! { |k, _| k == city }

      raise "Not found #{city}" unless item

      lat = item[city][0]
      lng = item[city][1]

      time_zone = NearestTimeZone.to(lat.to_f, lng.to_f)
    end

    ISO_TIME = /\A(\d\d):(\d\d)\z/

    # returns UTC
    def self.string_to_time(string, method, time_zone)
      # https://github.com/rails/rails/blob/aeba121a83965d242ed6d7fd46e9c166079a3230/activemodel/lib/active_model/type/helpers/time_value.rb#L65

      if string =~ ISO_TIME

        if method == :utc
          offset = 0 # UTC +0
          current_time = Time.new.utc

          Time.new(
            current_time.year,
            current_time.month,
            current_time.day,
            $1.to_i,
            $2.to_i,
            0,
            offset
          )
        else
          current_time = Time.new
          offset = Time.zone_offset(time_zone)

          Time.new(
            current_time.year,
            current_time.month,
            current_time.day,
            $1.to_i,
            $2.to_i,
            0,
            offset
          )
        end
      end
    end
end
