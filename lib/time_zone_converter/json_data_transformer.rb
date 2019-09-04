require 'json'

module TimeZoneConverter
  class JsonDataTransformer

    def initialize(path: 'data/cities')
      @path = path
    end

    def call
      json_new = Hash.new { |hash, key| hash[key] = {} }

      Dir["#{@path}/*.json"].each do |json_file|
        json = JSON.parse(File.read(json_file))
        json.each do |item|
          data = item.last
          json_new[data['accentcity']] = [data['latitude'], data['longitude']]
        end
      end

      File.open("#{@path}/cities.json", "w") do |f|
        f.write(json_new.to_json)
      end
    end
  end
end
