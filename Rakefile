require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

ADAPTERS = YAML.load(File.read(File.dirname(__FILE__) + "/spec/database.yml")).keys

desc "Run specs under all supported databases"
task :spec => ADAPTERS.map { |a| "spec:#{a}" }
task :default => :spec

namespace :spec do
  ADAPTERS.each do |adapter|
    namespace :prepare do
      task adapter do
        ENV["POPULATOR_ADAPTER"] = adapter
      end
    end

    desc "Run specs under #{adapter}"
    RSpec::Core::RakeTask.new(adapter => "spec:prepare:#{adapter}") do |t|
      t.verbose = false
    end
  end
end
