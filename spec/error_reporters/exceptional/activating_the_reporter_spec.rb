require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe FailFast::ErrorReporter::Exceptional do

  it 'is activated with FailFast.report_to :exceptional => <your-exceptional-api-key>' do

    FailFast.report_to(:exceptional => VALID_EXCEPTIONAL_API_KEY)   # <-- Activating the reporter

    # test :
    FailFast.new.error_reporters.collect{|o|o.class}.
        should == [FailFast::ErrorReporter::Stdout, FailFast::ErrorReporter::Exceptional]
    #                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #                                                 The new default errors reporter
  end

end