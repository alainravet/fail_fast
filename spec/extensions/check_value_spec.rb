require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'has_value_for()' do

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
    it "should not raise an error when a prefix is used" do
      lambda {
        FailFast(SIMPLE_FILE_PATH, 'test').check do
          has_value_for 'mongoDB/host',    /localhost/
        end
      }.should_not raise_error
    end
  end
end