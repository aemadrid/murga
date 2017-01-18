# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'murga/version'

Gem::Specification.new do |spec|
  spec.name          = 'murga'
  spec.version       = Murga::VERSION
  spec.authors       = ['Adrian Madrid']
  spec.email         = ['aemadrid@gmail.com']

  spec.summary       = %q{A simple JRuby web framework on top of Ratpack.}
  spec.description   = %q{A simple JRuby web framework on top of Ratpack.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'pry', '~> 0.10'
  spec.add_dependency 'activesupport', '4.2.7'
  spec.add_dependency 'jruby-openssl', '~> 0.9'
  spec.add_dependency 'bundler', '~> 1.13'
  # spec.add_dependency 'jbundler', '~> 0.9'
  spec.add_dependency 'jrjackson', '~> 0.4'
  spec.add_dependency 'rack', '~> 2.0.1'

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'http', '~> 2.0.1'
end
