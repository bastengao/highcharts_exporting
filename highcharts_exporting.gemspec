$:.push File.expand_path("../lib", __FILE__)

require "canvas_exporting/version"

Gem::Specification.new do |s|
  s.name        = "canvas_exporting"
  s.version     = CanvasExporting::VERSION
  s.authors     = ["jeffolen4","orangewolf"]
  s.email       = ["jmo@olen-inc.com","rob@notch8.com"]
  s.homepage    = "https://github.com/notch8/canvas_exporting"
  s.summary     = "canvas server exporting for Rails"
  s.description = "canvas server exporting for Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,phantomjs}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '>= 3.2', '< 5'
  s.add_dependency 'phantomjs'
  s.add_development_dependency 'rspec-rails'
end
