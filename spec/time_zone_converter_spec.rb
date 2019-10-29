require 'rspec-benchmark'
require 'timecop'

RSpec.describe TimeZoneConverter do
  include RSpec::Benchmark::Matchers

  it "has a version number" do
    expect(TimeZoneConverter::VERSION).not_to be nil
  end

  context 'when local' do
    context 'and when time passed in' do
      subject { described_class.call(["Warszawa", "Bangkok"], "10:00", :local) }

      time = Time.new(2019, 9, 15, 12, 0, 0, "+02:00")

      it "returns proper data" do
        Timecop.freeze(time) do
          expect(subject).to eq(
            [
              ["Warszawa", Time.parse('2019-09-15 10:00:00.000000000 +0200')],
              ["Bangkok", Time.parse('2019-09-15 15:00:00.000000000 +0700')]
            ]
          )
        end
      end
    end

    context 'and when time NOT passed in' do
      subject { described_class.call(["Warszawa", "Bangkok"], nil, :local) }

      it "returns proper data" do
        time = Time.new(2019, 9, 1, 12, 0, 0, "+02:00")

        Timecop.freeze(time) do
          expect(subject).to eq(
            [
              ["Warszawa", Time.parse('2019-09-01 12:00:00.000000000 +0200')],
              ["Bangkok", Time.parse('2019-09-01 17:00:00.000000000 +0700')]
            ]
          )
        end
      end
    end

    context 'and when time range passed in' do
      subject { described_class.call(["Warszawa", "Bangkok"], "10:00-12:00", :local) }

      it "returns proper data" do
        time = Time.new(2019, 9, 1, 12, 0, 0, "+02:00")

        Timecop.freeze(time) do
          expect(subject).to eq(
            [
              ["Warszawa", 
                [
                  Time.parse('2019-09-01 10:00:00.000000000 +0200'),
                  Time.parse('2019-09-01 12:00:00.000000000 +0200')
                ]
              ],
              ["Bangkok", 
                [
                  Time.parse('2019-09-01 15:00:00.000000000 +0700'),
                  Time.parse('2019-09-01 17:00:00.000000000 +0700')
                ]
              ]
            ]
          )
        end
      end
    end
  end

  context 'utc' do
    subject { described_class.call(["Warszawa", "Bangkok"], "10:00", :utc) }

    it "returns proper data" do
      time = Time.new(2019, 9, 15, 12, 0, 0, "+02:00")

      Timecop.freeze(time) do
        expect(subject).to eq(
          [
            ["Warszawa", Time.parse('2019-09-15 12:00:00.000000000 +0200')],
            ["Bangkok", Time.parse('2019-09-15 17:00:00.000000000 +0700')]
          ]
        )
      end
    end
  end

  it "shoud be faster than manual process" do
    expect do
      TimeZoneConverter.call(["Warszawa", "Bangkok"], "10:00", :local)
    end.to perform_under(11).secs
  end
end
