# -*- encoding: utf-8 -*-
require File.expand_path('../lib/stringtree/version', __FILE__)

Gem::Specification.new do |s|  
  s.authors       = ["Tom Cully"]
  s.email         = ["tomhughcully@gmail.com"]
  s.summary       = 'A String Trie for Ruby allowing partial string searches'
  s.description   = 'stringtree is design to allow efficient partial string searches/autocomplete and tokenization'
  s.homepage      = "http://github.com/tomdionysus/stringtree-ruby"
  s.required_ruby_version = '>= 1.9.3'
  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.name          = "stringtree"
  s.require_paths = ["lib"]
  s.version       = StringTree::VERSION

  s.add_development_dependency "coveralls"
  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency 'simplecov',        '~> 0.10.0'
  s.add_development_dependency 'simplecov-rcov',   '~> 0.2'
  s.add_development_dependency 'rdoc',             '~> 4.1'
  s.add_development_dependency 'sdoc',             '~> 0.4'
  s.add_development_dependency 'rspec',            '~> 3.1'
  s.add_development_dependency 'rspec-mocks',      '~> 3.1'
end  