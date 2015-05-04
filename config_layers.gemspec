# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'config_layers/version'

Gem::Specification.new do |spec|
  spec.name          = "config_layers"
  spec.version       = ConfigLayers::VERSION
  spec.date          = ConfigLayers::DATE
  spec.authors       = ["Christophe Larsonneur"]
  spec.email         = ["clarsonneur@gmail.com"]

  spec.summary       = %q{ConfigLayers, a simple multiple configuration management.}
  spec.description   = %q{Manage your application configuration files easily.}
  spec.homepage      = "http://github.com/forj-oss/config_layers"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "subhash", '~> 0.1.1'
  spec.add_runtime_dependency "pry"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "rubocop", "~> 0.30.0"
end
