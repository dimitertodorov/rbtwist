require 'rdoc/task'
require 'rspec/core/rake_task'
require 'logger'

logger=Logger.new(STDOUT)



SPEC_SUITES = [
    { :id => :base, :title => 'base tests', :pattern => "spec/base/\*\*/\*_spec.rb" },
    { :id => :opsware, :title => 'Opsware model tests', :pattern => "spec/opsware/\*\*/\*_spec.rb" },
    #{ :id => :integration, :title => 'Opsware Integration tests (Requires connection to HPSA)', :pattern => "spec/integration/\*\*/\*_spec.rb" }
    #{ :id => :misc, :title => 'misc tests',
    #  :pattern => ["spec/lib/\*\*/\*_spec.rb", "spec/mailers/\*\*/\*_spec.rb"] },
]

namespace :spec do
  namespace :suite do
    SPEC_SUITES.each do |suite|
      desc "Run all specs in #{suite[:title]} spec suite"
      RSpec::Core::RakeTask.new(suite[:id]) do |t|
        t.pattern = suite[:pattern]
        t.rspec_opts = '--format documentation --color'
        t.verbose = false
      end
    end
    desc "Run all spec suites"
    task :all do
      SPEC_SUITES.each do |suite|
        logger.info "Running #{suite[:title]} ..."
        Rake::Task["spec:suite:#{suite[:id]}"].execute
      end
    end
  end
end


require 'jeweler'
require './lib/rbtwist/version'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "rbtwist"
  gem.version = Rbtwist::Version::STRING
  gem.summary = "Ruby interface to the Opsware SOAP API"
  gem.email = "rlane@vmware.com"
  gem.homepage = "https://github.com/dimitertodorov/rbtwist"
  gem.authors = ["Dimiter Todorov"]
  gem.files = `git ls-files -- lib/* script/* [A-Z]* spec/* model_db/*`.split("\n")

  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new


