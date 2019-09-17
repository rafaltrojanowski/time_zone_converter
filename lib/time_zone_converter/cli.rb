require "thor"

module TimeZoneConverter
  class Cli < Thor

    desc 'c', "Current time in a cities"
      long_desc <<-LONGDESC
        It allows to answer the question:
        What time it is in x, y, z - right now!

        Takes list of the cities

        Returns array of arrays: [[city, time], [...]]

        Example: time_zone_converter c 'Chiang Mai' Skopje

        =>
          [
            ['Chiang Mai', Wed, 11 Sep 2019 14:44:18 +07 +07:00],
            ['Skopje', Wed, 11 Sep 2019 09:44:18 CEST +02:00]
          ]
      LONGDESC
    def c(*args)
      puts TimeZoneConverter.call(args, nil, :local).inspect
    end

    desc 'ct', "Given time in a cities"
      long_desc <<-LONGDESC
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
      LONGDESC
    def ct(*args, method: :local)
      cities = args.shift(args.size - 1)
      time = args.first
      puts TimeZoneConverter.call(cities, time, method).inspect
    end

    desc 'ctu', "Given UTC time in a cities"
      long_desc <<-LONGDESC
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
      LONGDESC
    def ctu(*args, method: :utc)
      cities = args.shift(args.size - 1)
      time = args.first
      puts TimeZoneConverter.call(cities, time, method).inspect
    end
  end
end
