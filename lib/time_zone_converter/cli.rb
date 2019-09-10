require "thor"

module TimeZoneConverter
  class Cli < Thor

    desc 'c',
      "
        TODO:
      "

    def c(*args)
      puts TimeZoneConverter.call(args).inspect
    end

    desc 'ctu',
      "
        Takes cities list and time (in UTC), and return array of [city, time (with zone)]
        Example: time_zone_converter ctu Bangkok Warszawa '10:00'
        => [
             ['Bangkok', Tue, 10 Sep 2019 17:00:00 +07 +07:00],
             ['Warszawa', Tue, 10 Sep 2019 12:00:00 CEST +02:00]
           ]

      "
    def ctu(*args)
      cities = args.shift(args.size - 1)
      time = args.first
      puts TimeZoneConverter.call(cities, time).inspect
    end
  end
end
