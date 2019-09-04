require "thor"

module TimeZoneConverter
  class Cli < Thor

    desc 'c',
      "
        TODO:
      "

    def c(city_a, city_b, time = Time.now)
      puts TimeZoneConverter.call(
        city_a: city_a,
        city_b: city_b,
        time: time,
      ).inspect
    end
  end
end
