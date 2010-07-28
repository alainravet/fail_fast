require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe 'is_on_path' do

  context '' do
    it_should_not_raise_an_error('when the app is on the path') {
      is_on_path 'ls'
    }

    it_should_raise_a_direct_error('ls987654321', :not_on_path, 'when the app is not on the path' ) {
      is_on_path 'ls987654321'
    }
  end

  context '_for' do
    it_should_not_raise_an_error('when the app is on the path') {
      is_on_path_for 'app_on_path'
    }

    it_should_raise_an_error('app_not_on_path', :not_on_path, 'when the app is not on the path' ) {
      is_on_path_for 'app_not_on_path'
    }
  end

  it "should accept a custom message for the 3 cases" do
    FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
      is_on_path 'ls987654321',         :message => 'a_custom_message'
      is_on_path_for 'INCONNU',         :message => 'a_custom_message_2'
      is_on_path_for 'app_not_on_path', :message => 'a_custom_message_3'
    end
    messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
    messages.should =~ %w(a_custom_message a_custom_message_2 a_custom_message_3)
  end
end
