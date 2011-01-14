require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "kindlemail"
  gem.homepage = "http://github.com/djhworld/kindlemail"
  gem.license = "MIT"
  gem.summary = %Q{Push documents to your kindle via the personal document service}
  gem.description = %Q{Sends documents to a designated kindle address painlessly and via the CLI. No need to fumble around with clumsy attachment boxes so forth, just whack in the documents you want to send and hit enter}
  gem.email = "djharperuk@gmail.com"
  gem.authors = ["Daniel Harper"]
  gem.required_ruby_version = '>= 1.9.2'
  gem.add_dependency "gmail-mailer", "= 0.4.2"
  gem.add_dependency "trollop", "~> 1.16.2"
end
Jeweler::RubygemsDotOrgTasks.new

