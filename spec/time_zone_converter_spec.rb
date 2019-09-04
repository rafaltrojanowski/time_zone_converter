RSpec.describe TimeZoneConverter do
  it "has a version number" do
    expect(TimeZoneConverter::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(TimeZoneConverter.call(
      city_a: "Warszawa",
      city_b: "Bankok"
    )).to_not be_empty
  end
end
