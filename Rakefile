require 'rdoc/task'
#require 'yard'


begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '--format documentation --color'
  end
rescue LoadError
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


#YARD::Rake::YardocTask.new
