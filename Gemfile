source 'http://rubygems.org'

gem 'slop', '~> 3.4'
gem 'mechanize', '~> 2.7'

group :test do
  gem 'rake'
end

group :development do
  gem 'rspec'
  gem 'rr'
  gem 'bundler'
  gem 'jeweler', '~> 1.8'
  gem 'pry-byebug'
  gem 'cucumber'
  gem 'aruba'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'terminal-notifier-guard' if RUBY_PLATFORM.downcase.include?('darwin12')
end
