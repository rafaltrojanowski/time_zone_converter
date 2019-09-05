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

    desc 'ct',
      "
        TODO:
      "
    def ct(*args)
      cities = args.shift(args.size - 1)
      time = args.first
      puts TimeZoneConverter.call(cities, time).inspect
    end
  end
end
