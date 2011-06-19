# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name          =   'fail_fast'
  s.version       =   '0.6.0'

  s.date          =   Time.now.utc.strftime("%Y-%m-%d")
  s.homepage      =   'http://github.com/alainravet/fail_fast'

  s.summary       =   'raises an error if the yaml contents of a config file does pass a test script.'
  s.description   =   'raises an error if the yaml contents of a config file does pass a test script.'

  s.authors       =   'Alain Ravet'
  s.email         =   'alain.ravet@gmail.com'
  s.extra_rdoc_files = %w(LICENSE README.markdown)
  s.rdoc_options  =   ["--charset=UTF-8"]

  s.platform    = Gem::Platform::RUBY
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths =   %w(lib)

  s.add_development_dependency 'rspec',         '= 1.3.2'
  s.add_development_dependency 'activerecord',  '= 2.3.12'
  s.add_development_dependency 'mongo',         '>= 0'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'bson_ext'
  s.add_development_dependency 'bson_ext'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'vcr'
end
