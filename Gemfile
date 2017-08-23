gem_sources   = ENV.key?('GEM_SERVERS') ? ENV['GEM_SERVERS'].split(/[, ]+/) : ['https://rubygems.org']

gem_sources.each { |gem_source| source gem_source }

# read dependencies in from the gemspec
gemspec

group :development do
  gem 'pry'
  gem 'pry-byebug'
end
