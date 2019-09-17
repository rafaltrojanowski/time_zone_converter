require 'json'

module TimeZoneConverter
  class JsonDataTransformer

    DATA_PATH = 'data/cities'

    def initialize(path: DATA_PATH)
      @path = path
    end

    def call
      json_new = Hash.new { |hash, key| hash[key] = {} }

      Dir["#{@path}/*.json"].each do |json_file|
        json = JSON.parse(File.read(json_file))
        json.each do |item|
          data = item.last

          next unless data.is_a? Hash

          accentcity = data['accentcity']

          if json_new[accentcity].present?
            puts "#{accentcity} already exists."
            population = data['population']
            population_to_i = population.to_i || 0

            previous_population_to_i = json_new[accentcity].try(:last).to_i || 0

            if previous_population_to_i < population_to_i
              puts "Overriding #{accentcity}."
              puts "Population was #{previous_population_to_i}."
              puts "Population is #{population_to_i}."
              # sleep 0.1

              json_new[accentcity] = [
                data['latitude'],
                data['longitude'],
                population
              ]
            end
          else
            puts "#{accentcity} will be created."

            json_new[accentcity] = [
              data['latitude'],
              data['longitude'],
              data['population']
            ]
          end

          # sleep 0.05
        end
      end

      puts "Storing #{json_new.keys.count} cities."

      File.open("#{@path}/cities.json", "w") do |f|
        f.write(json_new.to_json)
      end
    end
  end
end
