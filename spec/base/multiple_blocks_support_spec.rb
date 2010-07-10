require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "FailFast.check_now.but_fail_later" do
  before(:all) { capture_stdout }
  after( :all) { restore_stdout }

  it 'should not raise an error on the check(..) call' do
    lambda {
      FailFast(UNKNOWN_FILE_PATH).check_now.but_fail_later {}
    }.should_not raise_error
    FailFast.global_errors.collect(&:kind).should == [:config_file_not_found]
  end

  context 'when there are errors in the first 2 of 3 blocks' do
    before(:each) do
      FailFast(UNKNOWN_FILE_PATH).check_now.but_fail_later {}
      FailFast(SIMPLE_FILE_PATH ).check_now.but_fail_later {
        has_value_for 'AN-UNKNOWN-KEY'
        has_value_for 'AN-UNKNOWN-KEY-2'
      }
      FailFast(EMPTY_FILE_PATH  ).check_now.but_fail_later {} #no errors in the last block
    end

    it("should detect and collect all the errors") {
      FailFast.errors_db.errors_for(FailFast::ErrorDb.key_for(UNKNOWN_FILE_PATH)).collect(&:kind).should == [:config_file_not_found]
      FailFast.errors_db.errors_for(FailFast::ErrorDb.key_for(SIMPLE_FILE_PATH )).collect(&:kind).should == [:missing_value, :missing_value]
      FailFast.errors_db.errors_for(FailFast::ErrorDb.key_for(EMPTY_FILE_PATH  )).collect(&:kind).should == []
    }
    context "after FailFast.fail_now" do
      it "should raise an error" do
        lambda {
          FailFast.fail_now
        }.should raise_error(ExitTriggered)
      end
    end
  end
end
