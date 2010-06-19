require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'directory_exists_for' do
  it_should_not_raise_an_error('when the directory exists') { directory_exists_for 'test/a_directory' }
  it_should_raise_an_error('when the directory path points to a File', /directory.*not exist/) { directory_exists_for 'test/a_file' }
  it_should_raise_an_error('when the directory does not exist', /directory.*not exist/) { directory_exists_for 'test/email' }
  it_should_raise_an_error('when the key is invalid', /missing or blank value.*not_a_valid_key/) { directory_exists_for 'not_a_valid_key' }
end

describe 'file_exists_for' do
  it_should_not_raise_an_error('when the file exists') { file_exists_for 'test/a_file' }
  it_should_raise_an_error('when the file path points to a Directory', /file.*not exist/) { file_exists_for 'test/a_directory' }
  it_should_raise_an_error('when the file does not exist', /file.*not exist/) { file_exists_for 'test/email' }
  it_should_raise_an_error('when the key is invalid', /missing or blank value.*not_a_valid_key/) { file_exists_for 'not_a_valid_key' }
end