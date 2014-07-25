source 'http://rubygems.org'

gem 'slop'
gem 'mechanize'

group :test do
  gem 'rake'
end

group :development do
  gem 'rspec'
  gem 'rr'
  gem 'bundler'
  gem 'jeweler', '~> 1.8.8'
  gem 'pry-debugger'
  gem 'cucumber'
  gem 'aruba'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'terminal-notifier-guard' if RUBY_PLATFORM.downcase.include?('darwin12')
end
