require 'vcr'

VCR.config do |c|
  c.cassette_library_dir     = 'spec/_vcr_cassette_library'
  c.stub_with                :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
end
Spec::Runner.configure do |config|
  config.extend VCR::RSpec::Macros
end
