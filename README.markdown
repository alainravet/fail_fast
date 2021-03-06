# fail_fast : don't start your application if some preconditions are not met.

## How to install :

    gem install fail_fast

## How to use :


### Example 0 : don't start the application on Sunday or if '_why' cannot be found (on the PATH).

Insert this code early in your program starting sequence :

	require 'fail_fast'
	FailFast().check do
	  is_on_path '_why'
      fail "I don't work on Sunday" if 0 == Time.now.wday
	end


If _\_why_ can't be found :  
* the application will exit immediately and    
* you will see this report :


    +------------------------------------------------------------------------------------------
    |   FAIL_FAST error : precondition(s) not met.
    +------------------------------------------------------------------------------------------
    |  _why could not be found on the path
    +------------------------------------------------------------------------------------------



### Example 1 : don't start the application if the DB cannot be reached.

Early in your project boot sequence insert this code :

	require 'fail_fast'
	FailFast("path/to/database.yml").check do
	  has_active_record_db_for  'production', :message => 'The main DB cannot be reached :'
	end

remark : the :message part is always optional.


If the DB connection fails,   
* the application will exit immediately and    
* you will see this report :
  

    +------------------------------------------------------------------------------------------
    |   FAIL_FAST error : precondition(s) not met in
    |  -----------------
    |     file         :  "path/to/database.yml"
    +------------------------------------------------------------------------------------------
    |      error                                   key                                value
    +------------------------------------------------------------------------------------------
    |  The main DB cannot be reached :
    |  * active_record_db_connection_error      production                          Unknown database 'a_db'
    +------------------------------------------------------------------------------------------

Remark :  `check` will call `exit(1)` at the end of the first block with an error.   
If you want to collect and report all the errors before exiting, use `check_now.but_fail_later` (see Example 2 below).

### Example 2 : collect errors in multiple blocks.


	require 'fail_fast'
	FailFast('database.yml').check_now.but_fail_later do
	  has_active_record_db_for  'production'
	end

	FailFast('database.mongo.yml').check_now.but_fail_later do
	  has_mongoDB_for   Rails.env
	end
	
	FailFast('path_to/config.yml', prefix=Rails.env).check_now.but_fail_later do
	  has_values_for    'author/fname', 'author/lname'
	  has_email_for     'newsletter/to_address'
	
	  only_if Rails.env.production? do
	    has_url_for       'bug_tracker/url', :reachable => true
	  end
	
	  directory_exists_for  '/tmp', :message => 'the log '
	  file_exists_for       'public/nda.pdf'
	
	  skip_if Rails.env.development? do
	    fail "I don't work on Sunday" if 0 == Time.now.wday
	   end
	end
	
	FailFast.fail_now   # exit it an error was detected in any of the 3 blocks above.


If it fails, you'll get a report like this :
    
    +------------------------------------------------------------------------------------------
    |   FAIL_FAST error : precondition(s) not met in
    |  -----------------
    |     file         :  "path/to/database.yml"
    |     keys prefix  :  (none)
    +------------------------------------------------------------------------------------------
    |      error                                   key                                value
    +------------------------------------------------------------------------------------------
    |  * active_record_db_connection_error      production                          Unknown database 'a_db'
    +------------------------------------------------------------------------------------------

    +------------------------------------------------------------------------------------------
    |   FAIL_FAST error : precondition(s) not met in
    |  -----------------
    |     file         :  "./spec/_/fixtures/simple.yml"
    |     keys prefix  :  none
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
    |  * directory_not_found                    test/a_file                         ./spec/_/fixtures/simple.yml
    |  * file_not_found                                                             /tmp/foo/bar/??nOTaFile        
    |  * file_not_found                         test/a_directory                    ./spec/_/fixtures
    |  * mongoDB_server_not_found                                                   10.0.0.123                     
    |  * mongoDB_server_not_found               test/mongoDB                        localhost                      
    |  * mongoDB_db_not_found                                                       not_a_known_db                 
    |  * mongoDB_db_not_found                   test/unknown_mongoDB_db             unknown_mongoDB_db             
    |  * active_record_db_connection_error                                          Unknown database 'some-db'     
    |  * active_record_db_connection_error      db_connection                       Unknown database 'a_db'
    |  * fail                                                                       a custom failure message
    +------------------------------------------------------------------------------------------

### Example 3 : capture - and handle - individual errors

	FailFast().check_now.but_fail_later do
	  directory_exists_for  '/cache'                # default error handling/message

	  unless directory_exists_for  '/log'           # custom error handling
	    puts "The /log directory is missing"        #  ...
	    puts "create it with $ mkdir /log"          #  ...
	  end                                           #  ...
	end

	FailFast.fail_now   # exit it an error was detected in any of the 3 blocks above.


### Example 4 : print an additional custom message if errors were detected

	...	# code like in the cases above.

	if FailFast.failed?
        puts "Cannot start the application due to the problems mentioned above."
		puts "You can skip those test with the SKIP_FAIL_FAST environment variable"
		FailFast.fail_now	unless 'true'==ENV['SKIP_FAIL_FAST']
	end


### Example 5a : send errors report to Hoptoad (http://hoptoadapp.com)

    FailFast().check do
        ...                 # errors only reported to stdout
	end
    ...
    require 'hoptoad_notifier'
	FailFast.report_to :hoptoad => '<your-api-token>'       # <- add this in your FF script
    ...
    FailFast().check do
        ...                 # errors are (also) reported to your Hoptoad account
	end



### Example 5b : send errors report to Exceptional (http://getexceptional.com)

    FailFast().check do
        ...                 # errors only reported to stdout
	end
    ...
    require 'exceptional'                                       # <- add this in your FF script
	FailFast.report_to :exceptional => '<your-api-token>'       # <- add this in your FF script
    ...
    FailFast().check do
        ...                 # errors are (also) reported to your Hoptoad account
	end


Remark : Error reporters

- :stdout is the default (cannot be disabled)
- you can combine the error reporters (ex: stdout + :hoptoad + :exceptional)


## Info :

This gem DSL lets you write preconditions-scripts that you run early in the boot sequence of an application.
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

	fail "I don't work on Sunday" if (0 == Time.now.wday)

	directory_exists      '/tmp'
	file_exists           '/Users/me/.bash_profile'
	has_mongoDB           'localhost', 'db_app_1'
	has_active_record_db  :host => 'dbserv', :adapter => 'mysql', :database => 'db'

### _keyed_ commands (linked to a value found in a yaml file) :

####Test values linked to a key :   

*presence :*

	has_value_for   :application_name
	has_values_for  'author/fname', 'author/lname'

*contents <-> a regexp or pattern :*

	has_value_for   'level',  /(alpha|beta|production)/   
	has_url_for     'bug_tracker/url'   
	has_email_for   'newsletter/to_address'   

* customize it

    nda_file = value_of(:nda_file)
    fail 'NDA is too old' if (Time.now - File.mtime(nda_file))  > (24 * 60 * 60) * 365

Test the file system and .. :

	directory_exists    '/home/ci/uploads'
	file_exists         '/home/ci/config/secret.key'

    # the keyed version :
	directory_exists_for  'assets-upload_dir'
	file_exists_for       'assets-nda_pdf_file'

	is_on_path      'jruby'         # fail if jruby cannot be found 
	is_on_path_for  :ruby_engine


Test external services :

	# is a webserver up ?
	has_url_for     'bug_tracker/url', :reachable => true
	has_url_for     'bug_tracker/url', :reachable => true, :may_add_trailing_slash => true

	# can we connect to a mongoDB db/server :
	has_mongoDB_for   'test/mongoDB'
	has_mongoDB_for   'test/unknown_mongoDB_db', :check_database => false
	
	# can we connect to a SQL db :
	has_active_record_db_for 'production/db_connection'
	
Misc :

	fail "I don't work on Sunday" if 0 == Time.now.wday

Control commands :

	skip_if <condition> do .. end
	only_if <condition> do .. end
