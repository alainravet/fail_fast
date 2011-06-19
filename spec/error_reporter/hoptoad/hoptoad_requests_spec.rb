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

#--------------------------------------------------------

  before { Timecop.freeze(FROZEN_TIME); } #capture_stdout}
  after  { Timecop.return             ; } #restore_stdout}
  before do
    @api_key  = VALID_HOPTOAD_API_KEY
    @reporter = FailFast.report_to(:hoptoad => @api_key).first
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

end