# fail_fast : don't start your application if some preconditions are not met.

## How to use :

Early in your project boot sequence insert code like

    require 'fail_fast'
    FailFast('database.yml').check do
      has_active_record_db_for Rails.env
    end

    FailFast('database.mongo.yml').check do
      has_mongoDB_for Rails.env
    end

    FailFast('path_to/config.yml', prefix=Rails.env).check do
      has\_values_for 'author/fname', 'author/lname'
      has\_url_for 'bug_tracker/url', :reachable => true
      has\_email_for 'newsletter/to_address'

      directory_exists_for  '/tmp'
      file_exists_for       'public/nda.pdf'
    end


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

    directory_exists  '/tmp'
    file_exists       '/Users/me/.bash_profile'
    has_mongoDB           'localhost', 'db_app_1'
    has_active_record_db  :host => 'dbserv', :adapter => 'mysql', :database => 'db'


### _keyed_ commands (linked to a value found in a yaml file) :

####Test values linked to a key :   

*presence :*

      has_value_for :application_name
      has_values_for 'author/fname', 'author/lname'

*contents <-> a regexp or pattern :*

      has_value_for   'level',  /(alpha|beta|production)/   
      has_url_for     'bug_tracker/url'   
      has_email_for   'newsletter/to_address'   

Test the file system :

      directory_exists_for  'public/assets'
      file_exists_for       'public/500_custom.html'

Test external services :

    # is a webserver up ?
    has_url_for 'bug_tracker/url', :reachable => true
    has_url_for 'bug_tracker/url', :reachable => true, :may_add_trailing_slash => true


    # can we connect to a mongoDB db/server :
    has_mongoDB_for 'test/mongoDB'
    has_mongoDB_for 'test/unknown_mongoDB_db', :check_database => false

    # can we connect to a SQL db :
    has_active_record_db_for 'production/db_connection'

