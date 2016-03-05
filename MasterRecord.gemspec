# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "MasterRecord"
  s.version = "0.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Takeshi Morita"]
  s.date = "2011-12-20"
  s.description = "Object Mapper for csv or tsv or yaml etc.. you can use find,find_one_by|field|,find_by_|field|"
  s.email = "laten@nifty.com"
  s.extra_rdoc_files = [
    "ChangeLog",
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "ChangeLog",
    "Gemfile",
    "LICENSE.txt",
    "MasterRecord.gemspec",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "data/country.yml",
    "data/item.tsv",
    "data/user.csv",
    "lib/MasterRecord.rb",
    "lib/master_record/csv.rb",
    "lib/master_record/factory.rb",
    "lib/master_record/tsv.rb",
    "lib/master_record/yaml.rb",
    "spec/MasterRecord_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/takeshy/MasterRecord"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Object Mapper for csv or tsv or yaml."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

