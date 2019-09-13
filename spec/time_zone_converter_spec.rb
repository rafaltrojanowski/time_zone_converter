require 'rspec-benchmark'

RSpec.describe TimeZoneConverter do
  include RSpec::Benchmark::Matchers

  it "has a version number" do
    expect(TimeZoneConverter::VERSION).not_to be nil
  end

  it "shoud be as faster than manual process" do
    expect do
      TimeZoneConverter.call(["Warszawa", "Bangkok"])
    end.to perform_under(11).secs
  end
end
