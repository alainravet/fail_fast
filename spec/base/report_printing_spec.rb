require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "the printed error report" do
  before(:each) { capture_stdout }
  after( :each) { restore_stdout }

  it "contains an error details" do
    begin
      FailFast(SIMPLE_FILE_PATH).check { has_value_for :anykey }
    rescue
    end
    $stdout.string.should match(/error.*#{SIMPLE_FILE_PATH}.*missing value/mi)
  end


  it "contains an error details, even when we delay the failing" do
    FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later { has_value_for :unknown_key }
    $stdout.string.should match(/error.*#{SIMPLE_FILE_PATH}.*missing value/mi)
    $stdout.string.should match(/error.*#{SIMPLE_FILE_PATH}.*unknown_key/mi)
  end

  it "contains all errors details, in the right order, when they appear in 2 separate blocks" do
    FailFast(EMPTY_FILE_PATH ).check_now.but_fail_later { has_value_for :unknown_key_1 }
    FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later { has_value_for :unknown_key_2 }

    $stdout.string.should match(/error.*#{EMPTY_FILE_PATH }.*unknown_key_1.*#{SIMPLE_FILE_PATH}.*unknown_key_2/m)
  end

end
