source "https://rubygems.org"

gem "jets", "~> 4.0.0"


gem "zeitwerk", ">= 2.5.0"
gem "pg", "~> 1.5.4"
gem 'lockbox'
gem "faraday", "~> 2.7.10"
gem 'composite_primary_keys'
gem 'clockwork'
gem 'parallel'

# development and test groups are not bundled as part of the deployment
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop', require: false
end

group :test do
  gem 'rspec' # rspec test group only or we get the "irb: warn: can't alias context from irb_context warning" when starting jets console
end
