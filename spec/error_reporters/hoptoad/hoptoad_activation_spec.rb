require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe FailFast::ErrorReporter::Hoptoad do

  it 'is activated by adding it with FF#report_to to the global active error reporters' do
    FailFast.report_to :hoptoad => VALID_HOPTOAD_API_KEY

    FailFast.new.error_reporters.collect{|o|o.class}.
        should == [FailFast::ErrorReporter::Stdout, FailFast::ErrorReporter::Hoptoad]
    #                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #                                                 The new global errors reporter
  end

end