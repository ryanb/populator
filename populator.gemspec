Gem::Specification.new do |s|
  s.name        = "populator"
  s.version     = "1.0.0"
  s.author      = "Ryan Bates"
  s.email       = "ryan@railscasts.com"
  s.homepage    = "http://github.com/ryanb/populator"
  s.summary     = "Mass populate an Active Record database."
  s.description = "Mass populate an Active Record database."

  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"] - ["spec/test.sqlite3"]
  s.require_path = "lib"

  s.add_development_dependency 'rspec', '~> 2.1.0'
  s.add_development_dependency 'rails', '~> 3.0.3'
  s.add_development_dependency 'mocha', '~> 0.9.10'

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end
