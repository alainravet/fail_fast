# Prove that FailFast,
#  - register FailFast::ErrorReporter::Stdout  as default errors reporter.
#  - when it detects 1/many error(s), calls report(..) with the proper parameters on its errors reporter.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'FailFast and error reporters :' do

  let(:ff) {FailFast.new(nil,nil)}

  it 'only reports errors to Stdout by default' do
    ff.error_reporters.collect{|o|o.class}.should == [FailFast::ErrorReporter::Stdout]
  end

  it 'can register multiple error reporters' do
    ff.register_errors_reporter(DummyErrorReporter.new)
    ff.error_reporters.collect{|o|o.class}.should == [FailFast::ErrorReporter::Stdout, DummyErrorReporter]
  end

  it 'ignores duplicate registration' do
    ff.register_errors_reporter(DummyErrorReporter.new)
    ff.register_errors_reporter ff.error_reporters.first
    ff.register_errors_reporter ff.error_reporters.last
    ff.error_reporters.collect{|o|o.class}.should == [FailFast::ErrorReporter::Stdout, DummyErrorReporter]
  end


  it "calls all the registered reporters, when an error occurs" do
    ff.register_errors_reporter(DummyErrorReporter.new)
    ff.error_reporters[0].should_receive(:report).once
    ff.error_reporters[1].should_receive(:report).once

    ff.check_now.but_fail_later do                                            # = what we test!
      has_value_for(:www_unknown , :message => "www_unknown is missing" )     #
      has_value_for(:www_unknown2, :message => "www_unknown2 is missing")     #
    end                                                                       #
  end
end

describe FailFast do

  let(:error_1) { FailFast::ErrorDetails.new(:www_unknown , :missing_value, nil, "www_unknown is missing" ) }
  let(:error_2) { FailFast::ErrorDetails.new(:www_unknown2, :missing_value, nil, "www_unknown2 is missing") }
  let(:two_errors) { [error_1, error_2] }
  let(:two_errors_context) do {:errors_to_report =>  two_errors, :config_file_path =>  SIMPLE_FILE_PATH, :keys_prefix      =>  nil} end

  describe ".check_now" do
    it "passes all the detected errors and the context to Stdout.report" do
      FailFast(SIMPLE_FILE_PATH).tap do |ff|
        ff.error_reporters.first.should_receive(:report).with(two_errors, two_errors_context)  # the test
        begin
          ff.check_now do                                                         # = what we test!
            has_value_for(:www_unknown , :message => "www_unknown is missing" )   #
            has_value_for(:www_unknown2, :message => "www_unknown2 is missing")   #
          end                                                                     #
        rescue
        end
      end
    end
  end

  describe ".check_now.but_fail_later" do
    it "passes all the detected errors and the context to Stdout.report" do
      FailFast(SIMPLE_FILE_PATH).tap do |ff|
        ff.error_reporters.first.should_receive(:report).with(two_errors, two_errors_context)  # the test
        ff.check_now.but_fail_later do                                            # = what we test!
          has_value_for(:www_unknown , :message => "www_unknown is missing" )     #
          has_value_for(:www_unknown2, :message => "www_unknown2 is missing")     #
        end                                                                       #
      end
    end
  end
end
