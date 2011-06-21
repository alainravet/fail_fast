# Exceptional requests that the data is compressed before being sent
# -> we just test that FF triggers a post to the right uri, with the proper api key
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe FailFast::ErrorReporter::HoptoadGem do
  store_vcr_cassettes_next_to(__FILE__)


  let(:a_post_request_for_1_error_in_1_block){
    a_request(:post, 'http://hoptoadapp.com/notifier_api/v2/notices/').
        with(:headers => {'Accept'=>'text/xml, application/xml', 'Content-Type'=>'text/xml', 'User-Agent'=>'Ruby'},
             :body    => evaluate_xml_erb(File.join(File.dirname(__FILE__), 'expected_error_1_request.xml.erb'), false).gsub(/>\s+</,'><'))
  }

  let(:a_post_request_for_2_errors_in_1_block){
    a_request(:post, 'http://hoptoadapp.com/notifier_api/v2/notices/').
        with(:headers => {'Accept'=>'text/xml, application/xml', 'Content-Type'=>'text/xml', 'User-Agent'=>'Ruby'},
             :body    => evaluate_xml_erb(File.join(File.dirname(__FILE__), 'expected_error_2_request.xml.erb'), false).gsub(/>\s+</,'><'))
  }


#--------------------------------------------------------

  before do
    @api_key = VALID_HOPTOAD_API_KEY
    FailFast.report_to(:hoptoad_gem => @api_key).first
  end
#  before { capture_stdout} #for less console noise
#  after  { restore_stdout}

#--------------------------------------------------------


  context 'when 1 error occurs in 1 block' do
    use_vcr_cassette :record => :new_episodes

    it 'POSTs 1 request to http://plugin.gethoptoad.com:80/api/errors' do
      produce_1_error_in_1_check_block
      a_post_request_for_1_error_in_1_block.should have_been_made
    end
  end


  context 'when 2 errors occur in 1 block' do
    use_vcr_cassette :record => :new_episodes

    it 'POSTs 1 request to http://plugin.gethoptoad.com:80/api/errors' do
      produce_2_errors_in_1_check_block
      a_post_request_for_2_errors_in_1_block.should have_been_made
    end
  end


  context 'when 3 errors occur in 2 blocks' do
    use_vcr_cassette :record => :new_episodes

    it 'POSTs 2 requests to http://plugin.gethoptoad.com:80/api/errors' do
      produce_1_error_in_1_check_block
      produce_2_errors_in_1_check_block

      a_post_request_for_1_error_in_1_block .should have_been_made
      a_post_request_for_2_errors_in_1_block.should have_been_made
    end
  end

end
