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
  end
end
