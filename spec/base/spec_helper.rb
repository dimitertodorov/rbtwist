#Force 9.1 for base test
ENV['RBTWIST_SA_VERSION']='9.1'
require 'rbtwist'
Opsware = Rbtwist::Opsware
