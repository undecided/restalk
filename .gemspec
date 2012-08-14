require File.expand_path("../lib/restalk", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'restalk'
  gem.version = Restalk::VERSION
  gem.date    = Date.today.to_s

  gem.summary = "Abstraction layer between Beanstalk / Resque"
  gem.description = "Makes migrating from Beanstalk to resque (or back again) super-simple. Other backends welcome."

  gem.authors  = ['Matthew Bennett']
  gem.email    = 'matthew@quickwebdesign.net'
  gem.homepage = 'http://github.com/undecisive/restalk'

  #gem.add_development_dependency('rake')
  gem.add_dependency('beanstalk-client', ["1.0.2"])
  gem.add_dependency('resque', ['1.21.0'])

  # ensure the gem is built out of versioned files
  gem.files = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
end
