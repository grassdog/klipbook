require 'rubygems'
require 'bundler/setup'

require 'aruba/cucumber'

$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'klipbook'
require 'fileutils'

Before do
  aruba.config.exit_timeout = 40
end

