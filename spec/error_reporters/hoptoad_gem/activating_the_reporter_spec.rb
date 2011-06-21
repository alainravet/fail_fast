require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe FailFast::ErrorReporter::HoptoadGem do

  it 'is activated with FailFast.report_to :hoptoad => <your-exceptional-api-key>' do

    FailFast.report_to(:hoptoad_gem => VALID_HOPTOAD_API_KEY)   # <-- Activating the reporter

    # test :
    FailFast.new.error_reporters.collect{|o|o.class}.
        should == [FailFast::ErrorReporter::Stdout, FailFast::ErrorReporter::HoptoadGem]
    #                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #                                                 The new default errors reporter
  end

end