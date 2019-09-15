require 'rspec-benchmark'

RSpec.describe TimeZoneConverter do
  include RSpec::Benchmark::Matchers

  it "has a version number" do
    expect(TimeZoneConverter::VERSION).not_to be nil
  end

  context 'local' do
    subject { described_class.call(["Warszawa", "Bangkok"], "10:00", :local) }

    it "returns proper data" do
      expect(subject).to eq(
        [
          ["Warszawa", Time.parse('2019-09-15 10:00:00.000000000 +0200')],
          ["Bangkok", Time.parse('2019-09-15 15:00:00.000000000 +0700')]
        ]
      )
    end
  end

  context 'utc' do
    subject { described_class.call(["Warszawa", "Bangkok"], "10:00", :utc) }

    it "returns proper data" do
      expect(subject).to eq(
        [
          ["Warszawa", Time.parse('2019-09-15 12:00:00.000000000 +0200')],
          ["Bangkok", Time.parse('2019-09-15 17:00:00.000000000 +0700')]
        ]
      )
    end
  end

  it "shoud be faster than manual process" do
    expect do
      TimeZoneConverter.call(["Warszawa", "Bangkok"], "10:00", :local)
    end.to perform_under(10).secs
  end
end
