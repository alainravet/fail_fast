require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'has_value_for()' do

  context 'when the value is present' do
    it_should_not_raise_an_error('when the (string) key has a value') { has_value_for 'first_key' }
    it_should_not_raise_an_error('when the (symbol) key has a value') { has_value_for :last_key   }
    it_should_not_raise_an_error('when all the keys have a value'   ) { has_values_for 'first_key', :last_key   }
    it_should_not_raise_an_error('when the key is composed'         ) { has_value_for 'test/mongoDB/host',    /localhost/ }
  end

  context 'when the key is blank or absent' do
    it_should_raise_an_error('when the key is absent', /missing or blank value.*key_not_present/) {
      has_value_for :key_not_present
    }
    it_should_raise_an_error('when the key has a blank value', /missing or blank value.*key_with_blank_value/) {
      has_values_for 'first_key', :key_with_blank_value
    }
    it_should_raise_an_error('when one of the keys is absent', /missing or blank value.*key_not_present/) {
      has_values_for :first_key, :key_not_present
    }
    context 'because the key path is invalid' do
      it_should_raise_an_error('when the key path is invalid', /missing or blank value.*INVALID\/mongoDB\/host/) {
        has_value_for 'INVALID/mongoDB/host'
      }
    end
  end

  context 'when the value should match a regexp' do
    it_should_not_raise_an_error('when the value matches a regexp') { has_value_for 'test/host', /localhost/ }
    it_should_raise_an_error('when the value matches a regexp', /letter_x.*does not match.*localhost/) {
      has_value_for :letter_x, /localhost/
    }
  end

  context 'when the value must be in a range' do
    it_should_not_raise_an_error("when the value is in range ('a'..'z')") { has_value_for :letter_x,   :in => ('a'..'z') }
    it_should_raise_an_error('when the value is not in range (5..6)', /letter_x.*not in range 5..6/) {
      has_value_for :letter_x, :in => (5..6)
    }
    it_should_not_raise_an_error('when the value is in range (5..6)'    ) { has_value_for :number_six, :in => (5..6) }
    it_should_raise_an_error('when the value is not in range (5..6)', /number_six.*not in range "a".."z"/) {
      has_value_for :number_six, :in => ('a'..'z')
    }
  end

  context 'when the value must be in an array' do
    it_should_not_raise_an_error('when the value is in array [6, "x"]') {
      has_value_for :letter_x,   :in => [6, "x"]
      has_value_for :number_six, :in => [6, "x"]
    }
    it_should_raise_an_error('when the value is not in array [0, 1]', /number_six.*not in array \[0, 1\]/) {
      has_value_for :number_six, :in => [0, 1]
    }
  end

  context 'when a prefix is specified' do
    it "should not raise an error when a prefix is used" do
      lambda {
        FailFast.config_file(SIMPLE_FILE_PATH, 'test').check do
          has_value_for 'mongoDB/host',    /localhost/
        end
      }.should_not raise_error
    end
  end
end