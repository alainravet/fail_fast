require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "errors" do
  before(:each) { capture_stdout }
  after( :each) { restore_stdout }

  it "should use the filename and the prefix as key" do
    begin
      FailFast('invalid_file_path', 'a_prefix').check() do
        has_value_for :unknown
      end
    rescue
    end

    FailFast.errors_db.should have(1).keys
    FailFast.errors_db.keys.should == ["<invalid_file_path>a_prefix"]
  end
end
