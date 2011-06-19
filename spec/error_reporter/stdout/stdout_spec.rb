require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe FailFast::ErrorReporter::Stdout do
  before(:each) { capture_stdout }
  after( :each) { restore_stdout }

  context 'when 2 errors are detected in a config file' do
    before do
      produce_2_errors_in_1_check_block
    end
    it("prints to $stdout the config file path") do
      $stdout.string.should match(/error.*#{SIMPLE_FILE_PATH}/mi)
    end
    it "prints to $stdout the 1st error details" do
      $stdout.string.should match(/error.*msg-A.*missing value.*anykey_1/mi)
    end
    it "prints to $stdout the 2nd error details" do
      $stdout.string.should match(/error.*msg-B.*missing value.*anykey_2/mi)
    end
    it "prints everything in sequence and in the right order" do
      $stdout.string.should match(/error.*#{SIMPLE_FILE_PATH}.*msg-A.*missing value.*anykey_1.*msg-B.*missing value.*anykey_2/mi)
    end
  end
end
