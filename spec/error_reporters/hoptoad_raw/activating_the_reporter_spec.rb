require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe FailFast::ErrorReporter::HoptoadRaw do

  it 'is activated with FailFast.report_to :hoptoad_raw => <your-hoptoad-api-key>' do
    FailFast.report_to :hoptoad_raw => VALID_HOPTOAD_API_KEY

    FailFast.new.error_reporters.collect{|o|o.class}.
        should == [FailFast::ErrorReporter::Stdout, FailFast::ErrorReporter::HoptoadRaw]
    #                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #                                                 The new global errors reporter
  end

end