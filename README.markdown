# fail_fast : don't start your application if some preconditions are not met.

## How to install :

    gem install fail_fast

## How to use :

Early in your project boot sequence insert code like

    require 'fail_fast'
    FailFast('database.yml').check do
      has_active_record_db_for  Rails.env
    end

    FailFast('database.mongo.yml').check do
      has_mongoDB_for   Rails.env
    end

    FailFast('path_to/config.yml', prefix=Rails.env).check do
      has_values_for    'author/fname', 'author/lname'
      has_email_for     'newsletter/to_address'
      has_url_for       'bug_tracker/url', :reachable => true

      directory_exists_for  '/tmp'
      file_exists_for       'public/nda.pdf'

      fail "I don't work on Sunday" if 0 == Time.now.wday
    end

If it fails, you'll get a report like this :
    
    +------------------------------------------------------------------------------------------
    |   FAIL_FAST error : "./spec/fixtures/simple.yml"
    |   key prefix  = nil
    +------------------------------------------------------------------------------------------
    |      error                                   key                                value
    +------------------------------------------------------------------------------------------
    |  * missing_value                          first_keyNOT                                                       
    |  * missing_value                          last_keyNOT                                                        
    |  * missing_value                          number_sixNOT                                                      
    |  * missing_value                          testNOT/mongoDB/database                                           
    |  * value_does_not_match                   last_key                            dernier                        
    |  * not_an_email                           test/host                           localhost                      
    |  * not_a_url                              test/host                           localhost                      
    |  * url_not_reachable                      test/url_not_reachable              http://xxx.zzz                 
    |  * directory_not_found                                                        /foobarbaz                     
    |  * directory_not_found                    test/a_file                         ./spec/fixtures/simple.yml     
    |  * file_not_found                                                             /tmp/foo/bar/??nOTaFile        
    |  * file_not_found                         test/a_directory                    ./spec/fixtures                
    |  * mongoDB_server_not_found                                                   10.0.0.123                     
    |  * mongoDB_server_not_found               test/mongoDB                        localhost                      
    |  * mongoDB_db_not_found                                                       not_a_known_db                 
    |  * mongoDB_db_not_found                   test/unknown_mongoDB_db             unknown_mongoDB_db             
    |  * active_record_db_connection_error                                          Unknown database 'some-db'     
    |  * active_record_db_connection_error      db_connection                       Unknown database 'a_db'
    |  * fail                                                                       a custom failure message
    +------------------------------------------------------------------------------------------


## Info :

Failing fast is important.   
This gem DSL lets you write tests scripts that run early in the boot sequence of an application.    
An exception is raised if one or more tests fail, and you get a detailled report of all the problems encountered.

Some rules are based on the contents of configuration files (database.yml, config.yml, etc...) :   

- can a database connnection be established?
- is the mongoDB server active?
- is there an _:application\_name_ value in _config.yml_, and does it match a regexp pattern?
- is the value of _:info\_email__ a valid email?
- is the value of _:sponspor\_link_ a valid url, and is the site up?

You can also add custom rules, not related to any config files :

 - is there a _/tmp_, or an _public/upload_ directory on the server?
 - can the server access _http://google.com_?
 - is there a _public/nda\_pdf_ file?
 - etc..


## Features :

### _free/direct_ commands (not linked to the yaml file contents) :

      directory_exists      '/tmp'
      file_exists           '/Users/me/.bash_profile'
      has_mongoDB           'localhost', 'db_app_1'
      has_active_record_db  :host => 'dbserv', :adapter => 'mysql', :database => 'db'
      fail "I don't work on Sunday" if (0 == Time.now.wday)

### _keyed_ commands (linked to a value found in a yaml file) :

####Test values linked to a key :   

*presence :*

      has_value_for   :application_name
      has_values_for  'author/fname', 'author/lname'

*contents <-> a regexp or pattern :*

      has_value_for   'level',  /(alpha|beta|production)/   
      has_url_for     'bug_tracker/url'   
      has_email_for   'newsletter/to_address'   

Test the file system :

      directory_exists_for  'assets-upload_dir'
      file_exists_for       'assets-nda_pdf_file'

Test external services :

      # is a webserver up ?
      has_url_for     'bug_tracker/url', :reachable => true
      has_url_for     'bug_tracker/url', :reachable => true, :may_add_trailing_slash => true


      # can we connect to a mongoDB db/server :
      has_mongoDB_for   'test/mongoDB'
      has_mongoDB_for   'test/unknown_mongoDB_db', :check_database => false

      # can we connect to a SQL db :
      has_active_record_db_for 'production/db_connection'

