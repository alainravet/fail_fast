require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FailFast do

  let(:ff) {FailFast.new(nil,nil)}

  it 'reports errors only to FailFast::ErrorReporter::Stdout by default' do
    ff.error_reporters.collect{|o|o.class}.should == [FailFast::ErrorReporter::Stdout]
  end

  describe ".report_to" do
    it 'add errors reporters to the next FailFast check blocks that will be created' do
      FailFast.new(nil,nil).error_reporters.collect{|o|o.class}.should == [FailFast::ErrorReporter::Stdout]
      FailFast.report_to DummyErrorReporter.new
      FailFast.new(nil,nil).error_reporters.collect{|o|o.class}.should == [FailFast::ErrorReporter::Stdout, DummyErrorReporter]
    end
  end
end