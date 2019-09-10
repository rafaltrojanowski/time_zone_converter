require "thor"

module TimeZoneConverter
  class Cli < Thor

    desc 'ct',
      "
        It allows to answer the question:
        What time it is in x, y, z when in x there is HH:MM.

        Takes list of the cities and time (format: 'HH:MM' 24-hour).
        Time zone is taken from the first city in the list.

        Returns array of arrays: [[city, time], [...]]

        Example: time_zone_converter ct 'Chiang Mai' Skopje '19:00'
        =>
          [
            ['Chiang Mai', Tue, 10 Sep 2019 19:00:00 +07 +07:00],
            ['Skopje, Tue, 10 Sep 2019 14:00:00 CEST +02:00]
          ]
      "
    def ct(*args, method: :local)
      cities = args.shift(args.size - 1)
      time = args.first
      puts TimeZoneConverter.call(cities, time, method).inspect
    end

    desc 'ctu',
      "
        Similar as above (ct), with the exception that time is in UTC +0

        It allows to answer the question:
        What time it is in x, y, z when UTC time is HH:MM.

        Takes cities list and time (in UTC)

        Returns array of arrays: [[city, time], [...]]

        Example: time_zone_converter ctu Bangkok Warszawa '10:00'
        => [
             ['Bangkok', Tue, 10 Sep 2019 17:00:00 +07 +07:00],
             ['Warszawa', Tue, 10 Sep 2019 12:00:00 CEST +02:00]
           ]

      "
    def ctu(*args, method: :utc)
      cities = args.shift(args.size - 1)
      time = args.first
      puts TimeZoneConverter.call(cities, time, method).inspect
    end
  end
end
