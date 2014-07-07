# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'touth/version'

Gem::Specification.new do |spec|
  spec.name          = 'touth'
  spec.version       = Touth::VERSION
  spec.authors       = ['Yuki Iwanaga']
  spec.email         = ['yuki@creasty.com']
  spec.summary       = 'Simple token based authentication for Rails 4'
  spec.homepage      = 'https://github.com/creasty/touth'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.1.0'
  spec.add_dependency 'devise', '~> 3.2.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
