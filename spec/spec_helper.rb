require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'rr'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'klipbook'
