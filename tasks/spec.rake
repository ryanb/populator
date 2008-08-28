require 'spec/rake/spectask'

spec_files = Rake::FileList["spec/**/*_spec.rb"]

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = spec_files
  t.spec_opts = ["-c"]
end

namespace :spec do
  %w[mysql sqlite3].each do |adapter|
    namespace :prepare do
      task adapter do
        ENV["POPULATOR_ADAPTER"] = adapter
      end
    end
    
    desc "Run specs under #{adapter}"
    Spec::Rake::SpecTask.new(adapter => "spec:prepare:#{adapter}") do |t|
      t.spec_files = spec_files
      t.spec_opts = ["-c"]
    end
  end
end
