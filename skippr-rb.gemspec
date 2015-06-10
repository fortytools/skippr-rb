# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skippr/version'

Gem::Specification.new do |spec|
  spec.name          = "skippr-rb"
  spec.version       = Skippr::VERSION
  spec.authors       = ["Sebastian M. Gauck"]
  spec.email         = ["smg@42ls.de"]
  spec.description   = %q{gem to consume the api of our invoicing tool https://skippr.com}
  spec.summary       = %q{skippr api gem}
  spec.homepage      = "http://github.com/fortytools/skippr-rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency("activeresource")
end
