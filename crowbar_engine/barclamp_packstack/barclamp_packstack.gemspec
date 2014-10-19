$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "barclamp_packstack/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "barclamp_packstack"
  s.version     = BarclampPackstack::VERSION
  s.authors     = ["Greg Althaus"]
  s.email       = ["galthaus@austin.rr.com"]
  s.homepage    = ""
  s.summary     = " Summary of BarclampPackstack."
  s.description = " Description of BarclampPackstack."

  s.files = Dir["{app,config,db,lib}/**/*"] + [ "Rakefile", ]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
