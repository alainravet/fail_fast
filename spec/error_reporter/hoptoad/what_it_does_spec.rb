require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe FailFast::ErrorReporter::Hoptoad do

  let(:request_for_1_error_in_1_block){
    a_request(:post, 'http://hoptoadapp.com/notifier_api/v2/notices').
        with(:headers => {'Accept'=>'text/xml', 'Content-Type' => 'text/xml'},
             :body    => evaluate_xml_erb(File.join(File.dirname(__FILE__), 'expected_error_1_request.xml.erb')))

  }

  let(:request_for_2_errors_in_1_block){
    a_request(:post, 'http://hoptoadapp.com/notifier_api/v2/notices').
        with(:headers => {'Accept'=>'text/xml', 'Content-Type' => 'text/xml'},
             :body    => evaluate_xml_erb(File.join(File.dirname(__FILE__), 'expected_error_2_request.xml.erb')))

  }

  def produce_1_error_in_1_check_block
    FailFast(EMPTY_FILE_PATH).check.but_fail_later do
      is_on_path("azertyuiop")
    end
  end

  def produce_2_errors_in_1_check_block
    FailFast(SIMPLE_FILE_PATH).check.but_fail_later do
      is_on_path("azertyuiop")
      is_on_path("zizizouzou")
    end
  end

#--------------------------------------------------------

  before { Timecop.freeze(FROZEN_TIME); } #capture_stdout}
  after  { Timecop.return             ; } #restore_stdout}
  before do
    @api_key  = VALID_HOPTOAD_API_KEY
    @reporter = FailFast::ErrorReporter::Hoptoad.new(@api_key)
    FailFast.report_to @reporter
  end

#--------------------------------------------------------


  context 'when 1 errors occurs in 1 block' do
    use_vcr_cassette :record => :new_episodes

    it 'POSTs 1 xml request to hoptoadapp.com' do
      produce_1_error_in_1_check_block
      request_for_1_error_in_1_block.should have_been_made
    end
  end


  context 'when 2 errors occur in 1 block' do
    use_vcr_cassette :record => :new_episodes

    it 'POSTs 1 xml request to hoptoadapp.com' do
      produce_2_errors_in_1_check_block
      request_for_2_errors_in_1_block.should have_been_made
    end
  end


  context 'when 3 errors occur in 2 blocks' do
    use_vcr_cassette :record => :new_episodes

    it 'POSTs 2 xml requests to hoptoadapp.com' do
      produce_1_error_in_1_check_block
      produce_2_errors_in_1_check_block

      request_for_1_error_in_1_block .should have_been_made
      request_for_2_errors_in_1_block.should have_been_made
    end
  end


#--------------------------------------------------------
  context 'when the API token is invalid' do
    use_vcr_cassette :record => :new_episodes
    before do
      FailFast.init_global_error_reporters
      @reporter = FailFast::ErrorReporter::Hoptoad.new(@api_key=INVALID_HOPTOAD_API_KEY)
      FailFast.report_to @reporter
    end

    example 'POST => 422' do
      produce_1_error_in_1_check_block
      @reporter.response.code.to_i.should == 422
    end
  end


  context 'when the API token is valid' do
    use_vcr_cassette :record => :new_episodes

    before do
      FailFast.init_global_error_reporters
      @reporter = FailFast::ErrorReporter::Hoptoad.new(@api_key=VALID_HOPTOAD_API_KEY)
      FailFast.report_to @reporter
    end

    example 'POST => 200' do
      produce_1_error_in_1_check_block
      @reporter.response.code.to_i.should == 200
    end
  end

end