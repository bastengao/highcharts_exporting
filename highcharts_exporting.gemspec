$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "highcharts_exporting/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "highcharts_exporting"
  s.version     = HighchartsExporting::VERSION
  s.authors     = ["bastengao"]
  s.email       = ["bastengao@gmail.com"]
  s.homepage    = "https://github.com/bastengao/highcharts_exporting"
  s.summary     = "Highcharts server exporting for Rails"
  s.description = "Moutable Rails engine for Highcharts server exporting"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", '>= 3.2', '< 5'
  s.add_dependency "phantomjs"
  s.add_development_dependency 'rspec-rails'
end
