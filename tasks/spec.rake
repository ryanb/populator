require 'spec/rake/spectask'

ADAPTERS = YAML.load(File.read(File.dirname(__FILE__) + "/../spec/database.yml")).keys

desc "Run specs under all supported databases"
task :spec => ADAPTERS.map { |a| "spec:#{a}" }

namespace :spec do
  ADAPTERS.each do |adapter|
    namespace :prepare do
      task adapter do
        ENV["POPULATOR_ADAPTER"] = adapter
      end
    end
    
    desc "Run specs under #{adapter}"
    Spec::Rake::SpecTask.new(adapter => "spec:prepare:#{adapter}") do |t|
      t.spec_files = Rake::FileList["spec/**/*_spec.rb"]
      t.spec_opts = ["-c"]
    end
  end
end
