require 'vcr'

VCR.config do |c|
# c.cassette_library_dir     = 'spec/_vcr_cassette_library'
  c.stub_with                :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
end
Spec::Runner.configure do |config|
  config.extend VCR::RSpec::Macros
end

module VCR
  module RSpec
    module Macros

      # Usage:
      #   describe HttpFoo do
      #     store_vcr_cassettes_next_to(__FILE__)
      #
      def store_vcr_cassettes_next_to(base)
        new_location = File.join File.dirname(base), '_vcr_cassette_library'
        store_vcr_cassettes_in(new_location)
      end

      # Usage :
      #   describe HttpFoo do
      #     store_vcr_cassettes_next_in(File.dirname(__FILE)+ '/tapes')
      #
      def store_vcr_cassettes_in(new_location)
        old_location = VCR::Config.cassette_library_dir

        before do
          VCR::Config.cassette_library_dir = new_location
        end

        after do
          VCR::Config.cassette_library_dir = old_location
        end
      end
    end
  end
end

