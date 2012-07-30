require File.expand_path("../restalk", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'restalk'
  gem.version = Restalk::VERSION
  gem.date    = Date.today.to_s

  gem.summary = "Abstraction layer between Beanstalk / Resqueue"
  gem.description = "Makes migrating from Beanstalk to resqueue (or back again) super-simple. Other backends welcome."

  gem.authors  = ['Matthew Bennett']
  gem.email    = 'matthew@quickwebdesign.net'
  gem.homepage = 'http://github.com/undecisive'

  #gem.add_development_dependency('rake')
  gem.add_dependency('beanstalk-client', ["1.0.2"])
  gem.add_dependency('resque')

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
end
