# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'klipbook/version'

Gem::Specification.new do |spec|
  spec.name          = "klipbook"
  spec.version       = Klipbook::VERSION
  spec.authors       = ["Ray Grasso"]
  spec.email         = ["ray.grasso@gmail.com"]

  spec.summary       = "Klipbook creates a nice html summary of the clippings you've created on your Kindle."
  spec.description   = "Process your Kindle clippings file to generate a nicely formatted compilation of the clippings of the books you've read"
  spec.homepage      = "https://github.com/grassdog/klipbook"
  spec.licenses      = ["MIT"]

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "commander", "~> 4"
  spec.add_dependency "mechanize", "~> 2.7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "cucumber", "~> 2.4"
  spec.add_development_dependency "aruba", "~> 0.14"
end
