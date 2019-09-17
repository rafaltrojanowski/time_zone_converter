lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "time_zone_converter/version"

Gem::Specification.new do |spec|
  spec.name          = "time_zone_converter"
  spec.version       = TimeZoneConverter::VERSION
  spec.authors       = ["Rafał Trojanowski"]
  spec.email         = ["rt.trojanowski@gmail.com"]

  spec.summary       = %q{CLI which calculates time for a few cities.}
  spec.description   = %q{It doesn't use any external API and may be a slow with more arguments}
  spec.homepage      = "https://github.com/rafaltrojanowski/time_zone_converter"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'rspec-benchmark'
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "cities"

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "nearest_time_zone"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "oj"
end
