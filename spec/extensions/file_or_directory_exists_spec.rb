require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

a_dir   = SPEC_DIR + '/_/fixtures'
a_file  = SPEC_DIR + '/_/fixtures/simple.yml'


describe 'directory_exists' do
  context '' do
    it_should_return_true( 'when the directory exists'          ) { directory_exists a_dir }
    it_should_return_false('when the directory does not exists' ) { directory_exists 'XYZ'  }
    it_should_return_false('when the directory is a dir'        ) { directory_exists a_file  }

    it_should_not_raise_an_error('when the directory exists'                                            ) { directory_exists a_dir }

    it_should_raise_a_direct_error('XYZ',     :directory_not_found, 'when the directory does not exist' ) { directory_exists 'XYZ' }
    it_should_raise_a_direct_error(a_file,    :directory_not_found, 'when the path points to a File'    ) { directory_exists a_file}
  end

  context '_for' do
    it_should_return_true( 'when the file exists'          ) { directory_exists_for 'test/a_directory' }
    it_should_return_false('when the file does not exists' ) { directory_exists_for 'test/UNKNOWN'  }
    it_should_return_false('when the file is a dir'        ) { directory_exists_for 'test/a_file'  }

    it_should_not_raise_an_error('when the directory exists'                                            ) { directory_exists_for 'test/a_directory' }

    it_should_raise_an_error('test/a_file',   :directory_not_found, 'when the path points to a File'    ) { directory_exists_for 'test/a_file'      }
    it_should_raise_an_error('test/email',    :directory_not_found, 'when the directory does not exist' ) { directory_exists_for 'test/email'       }
    it_should_raise_an_error('not_a_valid_key',:missing_value,      'when the key is invalid'           ) { directory_exists_for 'not_a_valid_key'  }
  end

  it "accepts a custom message for the 5 cases" do
    FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
      directory_exists_for 'test/a_file', :message => 'a_custom_message'
      directory_exists_for 'test/email',  :message => 'a_custom_message_2'
      directory_exists_for 'INCONNU',     :message => 'a_custom_message_3'
      directory_exists 'XYZ',             :message => 'a_custom_message_4'
      directory_exists a_file,            :message => 'a_custom_message_5'
    end
    messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
    messages.should =~ %w(a_custom_message a_custom_message_2 a_custom_message_3 a_custom_message_4 a_custom_message_5)
  end
end


describe 'file_exists' do
  context '' do
    it_should_return_true( 'when the file exists'          ) { file_exists a_file }
    it_should_return_false('when the file does not exists' ) { file_exists 'XYZ'  }
    it_should_return_false('when the file is a dir'        ) { file_exists a_dir  }

    it_should_not_raise_an_error('when the file exists'                                                 ) { file_exists a_file}

    it_should_raise_a_direct_error('XYZ',     :file_not_found, 'when the file does not exist'           ) { file_exists 'XYZ' }
    it_should_raise_a_direct_error(a_dir,     :file_not_found, 'when the path points to a dir'          ) { file_exists a_dir }
  end

  context '_for' do
    it_should_return_true( 'when the file exists'          ) { file_exists_for 'test/a_file' }
    it_should_return_false('when the file does not exists' ) { file_exists_for 'test/UNKNOWN'  }
    it_should_return_false('when the file is a dir'        ) { file_exists_for 'test/a_directory'  }

    it_should_not_raise_an_error('when the file exists'                                                 ) { file_exists_for 'test/a_file' }

    it_should_raise_an_error('test/a_directory', :file_not_found,    'when the path points to a dir'    ) { file_exists_for 'test/a_directory'  }
    it_should_raise_an_error('test/email',       :file_not_found,    'when the file does not exist'     ) { file_exists_for 'test/email'        }
    it_should_raise_an_error('not_a_valid_key',  :missing_value,     'when the key is invalid'          ) { file_exists_for 'not_a_valid_key'   }
  end

  it "accepts a custom message for the 5 cases" do
    FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
      file_exists_for 'test/a_directory', :message => 'a_custom_message'
      file_exists_for 'test/email',       :message => 'a_custom_message_2'
      file_exists_for 'INCONNU',          :message => 'a_custom_message_3'
      file_exists 'XYZ',                  :message => 'a_custom_message_4' 
      file_exists a_dir,                  :message => 'a_custom_message_5'
    end
    messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
    messages.should =~ %w(a_custom_message a_custom_message_2 a_custom_message_3 a_custom_message_4 a_custom_message_5)
  end
end