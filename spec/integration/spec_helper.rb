ENV['RBTWIST_ENV']='test'

require 'rbtwist'
require 'yaml'


Opsware=Rbtwist::Opsware

::TEST_CONFIG=YAML.load(File.new('spec/integration/integration_config.yml'))

