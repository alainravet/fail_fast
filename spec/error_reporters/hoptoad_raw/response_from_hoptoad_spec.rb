require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe FailFast::ErrorReporter::HoptoadRaw do
  store_vcr_cassettes_next_to(__FILE__)

  context 'when the API token is invalid' do
    use_vcr_cassette :record => :new_episodes
    before do
      FailFast.send :reset_activated_error_reporters
      @api_key  = INVALID_HOPTOAD_API_KEY
      @reporter = FailFast.report_to(:hoptoad_raw => @api_key).first
    end

    example 'POST => 422' do
      produce_1_error_in_1_check_block
      @reporter.response.code.to_i.should == 422
    end
  end


  context 'when the API token is valid' do
    use_vcr_cassette :record => :new_episodes

    before do
      FailFast.send :reset_activated_error_reporters
      @api_key  = VALID_HOPTOAD_API_KEY
      @reporter = FailFast.report_to(:hoptoad_raw => @api_key).first
    end

    example 'POST => 200' do
      produce_1_error_in_1_check_block
      @reporter.response.code.to_i.should == 200
    end
  end

end