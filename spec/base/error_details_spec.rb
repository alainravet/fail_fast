require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FailFast::ErrorDetails do
  context 'with a static message' do
    subject {FailFast::ErrorDetails.new(:a_key, :a_kind, 'a_value', 'a_message')}
    its(:key    ){ should == :a_key     }
    its(:kind   ){ should == :a_kind    }
    its(:value  ){ should == 'a_value'  }
    its(:message){ should == 'a_message'}
  end
end
