require 'rubygems'
require 'bundler/setup'

$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'klipbook'
require 'fileutils'

TEST_DIR = File.expand_path('../../../tmp/test', __FILE__)
