require 'rubygems'
require 'bundler/setup'

require 'aruba/cucumber'

$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'klipbook'
require 'fileutils'

Before do
  @aruba_timeout_seconds = 40
end

Before('@slow') do
  @aruba_io_wait_seconds = 40
end
