# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: rbtwist 0.1.0.pre1 ruby lib

Gem::Specification.new do |s|
  s.name = "rbtwist"
  s.version = "0.1.0.pre1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dimiter Todorov"]
  s.date = "2015-01-21"
  s.email = "rlane@vmware.com"
  s.extra_rdoc_files = [
    "LICENSE.txt"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "Rakefile",
    "Readme.md",
    "lib/rbtwist.rb",
    "lib/rbtwist/basic_types.rb",
    "lib/rbtwist/connection.rb",
    "lib/rbtwist/const.rb",
    "lib/rbtwist/deserialization.rb",
    "lib/rbtwist/fault.rb",
    "lib/rbtwist/opsware.rb",
    "lib/rbtwist/opsware/Map.rb",
    "lib/rbtwist/opsware/ModifiableVO.rb",
    "lib/rbtwist/opsware/ServerRef.rb",
    "lib/rbtwist/opsware/mapItem.rb",
    "lib/rbtwist/response.rb",
    "lib/rbtwist/schema.rb",
    "lib/rbtwist/trivial_soap.rb",
    "lib/rbtwist/type_loader.rb",
    "lib/rbtwist/version.rb",
    "lib/rbtwist/wsdl.rb",
    "model_db/opsware_models_102.db",
    "model_db/opsware_models_91.db",
    "spec/ModifiableVO_spec.rb",
    "spec/deserialization_spec.rb",
    "spec/opsware_spec.rb",
    "spec/spec_helper.rb",
    "spec/xml/NotFoundException.xml",
    "spec/xml/ServerHardwareVO.xml",
    "spec/xml/ServerService.wsdl"
  ]
  s.homepage = "https://github.com/dimitertodorov/rbtwist"
  s.rubygems_version = "2.2.2"
  s.summary = "Ruby interface to the Opsware SOAP API"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.6.5"])
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.6.5"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.6.5"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end
