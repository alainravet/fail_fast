require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ConfigCheck on an empty file" do
  it_should_not_raise_an_error("when there are no checks") { }
  it_should_raise_an_error("when there is a has_value_for check", /missing or blank value.*any/) {
    has_value_for :anykey
  }
end
