require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

a_dir   = SPEC_DIR + '/fixtures'
a_file  = SPEC_DIR + '/fixtures/simple.yml'


describe 'directory_exists' do
  context '' do
    it_should_not_raise_an_error('when the directory exists'                                            ) { directory_exists a_dir }

    it_should_raise_a_direct_error('XYZ',     :directory_not_found, 'when the directory does not exist' ) { directory_exists 'XYZ' }
    it_should_raise_a_direct_error(a_file,    :directory_not_found, 'when the path points to a File'    ) { directory_exists a_file}
  end

  context '_for' do
    it_should_not_raise_an_error('when the directory exists'                                            ) { directory_exists_for 'test/a_directory' }

    it_should_raise_an_error('test/a_file',   :directory_not_found, 'when the path points to a File'    ) { directory_exists_for 'test/a_file'      }
    it_should_raise_an_error('test/email',    :directory_not_found, 'when the directory does not exist' ) { directory_exists_for 'test/email'       }
    it_should_raise_an_error('not_a_valid_key',:missing_value,      'when the key is invalid'           ) { directory_exists_for 'not_a_valid_key'  }
  end
end


describe 'file_exists' do
  context '' do
    it_should_not_raise_an_error('when the file exists'                                                 ) { file_exists a_file}

    it_should_raise_a_direct_error('XYZ',     :file_not_found, 'when the file does not exist'           ) { file_exists 'XYZ' }
    it_should_raise_a_direct_error(a_dir,     :file_not_found, 'when the path points to a dir'          ) { file_exists a_dir }
  end

  context '_for' do
    it_should_not_raise_an_error('when the file exists'                                                 ) { file_exists_for 'test/a_file' }

    it_should_raise_an_error('test/a_directory', :file_not_found,    'when the path points to a dir'    ) { file_exists_for 'test/a_directory'  }
    it_should_raise_an_error('test/email',       :file_not_found,    'when the file does not exist'     ) { file_exists_for 'test/email'        }
    it_should_raise_an_error('not_a_valid_key',  :missing_value,     'when the key is invalid'          ) { file_exists_for 'not_a_valid_key'   }
  end
end