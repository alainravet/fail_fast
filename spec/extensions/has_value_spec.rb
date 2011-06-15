require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'value_of()' do
  it 'returns nil when the value is blank' do
    FailFast(SIMPLE_FILE_PATH).check { @@val = value_of(:key_with_blank_value) }
    @@val.should be_nil
  end

  it 'returns nil when the key is unknown' do
    FailFast(EMPTY_FILE_PATH).check { @@val = value_of(:anykey) }
    @@val.should be_nil
  end
  it 'returns the value when it is a leaf'do
    FailFast(SIMPLE_FILE_PATH).check { @@val = value_of(:first_key) }
    @@val.should == 'premier'
  end

  it 'returns the values in a hash when the value is a tree' do
    FailFast(SIMPLE_FILE_PATH).check { @@val = value_of(:test) }
    @@val.should be_a(Hash)
    @@val['mongoDB']['host'].should == 'localhost'
  end

  it 'prepends the prefix to the key' do
    FailFast(SIMPLE_FILE_PATH, 'test').check { @@val = value_of(:mongoDB) }
    @@val['host'].should == 'localhost'
  end
end

describe 'has_value_for()' do
  before { capture_stdout }
  after  { restore_stdout }

  it "accepts a custom message for the 4 cases" do
    FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
      has_value_for 'inconnu',   /localhost/,       :message => 'a_custom_message'
      has_value_for :first_key,  /nomatchhere/,     :message => 'a_custom_message_2'
      has_value_for :letter_x,   :in => ('a'..'b'), :message => 'a_custom_message_3'
      has_value_for :letter_x,   :in => [6, "a"],   :message => 'a_custom_message_4'
    end

    messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
    messages.should =~ %w(a_custom_message a_custom_message_2 a_custom_message_3 a_custom_message_4)
  end


#-----------------
  context 'when the value is present' do
    it_should_not_raise_an_error('when the (string) key has a value') { has_value_for 'first_key' }
    it_should_not_raise_an_error('when the (symbol) key has a value') { has_value_for :last_key   }
    it_should_not_raise_an_error('when all the keys have a value'   ) { has_values_for 'first_key', :last_key   }
    it_should_not_raise_an_error('when the key is composed'         ) { has_value_for 'test/mongoDB/host',    /localhost/ }
  end

  context 'when the key is blank or absent' do
    it_should_raise_an_error('key_not_present', :missing_value, 'when the key is absent') {
      has_value_for :key_not_present
    }
    it_should_raise_an_error('key_with_blank_value', :missing_value, 'when the key has a blank value') {
      has_values_for 'first_key', :key_with_blank_value
    }
    it_should_raise_an_error('key_with_blank_value', :missing_value, 'when one of the keys is absent') {
      has_values_for :first_key, :key_with_blank_value
    }
    context 'because the key path is invalid' do
      it_should_raise_an_error('INVALID/mongoDB/host', :missing_value, 'when the key path is invalid') {
        has_value_for 'INVALID/mongoDB/host'
      }
    end
  end

  context 'when the value should match a regexp' do
    it_should_not_raise_an_error('when the value matches a regexp') { has_value_for 'test/host', /localhost/ }
    it_should_raise_an_error('letter_x', :value_does_not_match, 'when the value matches a regexp') {
      has_value_for :letter_x, /localhost/
    }
  end

  context 'when the value must be in a range' do
    it_should_not_raise_an_error("when the value is in range ('a'..'z')") { has_value_for :letter_x,   :in => ('a'..'z') }
    it_should_raise_an_error('letter_x', :value_not_in_range, 'when the value is not in range (5..6)') {
      has_value_for :letter_x, :in => (5..6)
    }
    it_should_raise_an_error('letter_x', :value_not_in_range, 'when the value is not in range (5..6)') {
      has_value_for :letter_x, :in => (5..6)
    }
    it_should_not_raise_an_error('when the value is in range (5..6)'    ) { has_value_for :number_six, :in => (5..6) }
    it_should_raise_an_error('number_six', :value_not_in_range, 'when the value is not in range (5..6)') {
      has_value_for :number_six, :in => ('a'..'z')
    }
  end

  context 'when the value must be in an array' do
    it_should_not_raise_an_error('when the value is in array [6, "x"]') {
      has_value_for :letter_x,   :in => [6, "x"]
      has_value_for :number_six, :in => [6, "x"]
    }
    it_should_raise_an_error('letter_x', :value_not_in_array, 'when the value is not in array [0, 1]') {
      has_value_for :letter_x, :in => [0, 1]
    }
  end

  context 'when a prefix is specified' do
    it "does not raise an error when a prefix is used" do
      lambda {
        FailFast(SIMPLE_FILE_PATH, 'test').check do
          has_value_for 'mongoDB/host',    /localhost/
        end
      }.should_not raise_error
    end
  end
end