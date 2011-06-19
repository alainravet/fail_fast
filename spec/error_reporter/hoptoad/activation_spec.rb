require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe FailFast::ErrorReporter::Hoptoad do

  it 'is activated by adding it with FF#report_to to the global active error reporters' do

    hoptoad_reporter = FailFast::ErrorReporter::Hoptoad.new(VALID_HOPTOAD_API_KEY)

    FailFast.report_to hoptoad_reporter # <-- add it to global FF reporters

    FailFast.new.error_reporters.collect{|o|o.class}.
        should == [FailFast::ErrorReporter::Stdout, FailFast::ErrorReporter::Hoptoad]
    #                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #                                                 The new global errors reporter
  end

end