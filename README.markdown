# fail_fast : fail fast if your application's config files don't match custom recipes.


Failing fast is important.   
This gem DSL lets you write tests scripts that run early in the boot sequence of an application. Those scripts specify a set of conditions to fulfill, based on the contents of the project YAML configuration files.   
If one - or more - tests fail, an exception is raised and you get a detailled report.

Some rules test the contents of the configuration file :   

-   the :application\_name must be specified.
-   the :state value must be 'on' or 'off'
-   the :sponsor\_link is a valid url
-   the :editor\_email is a valid email

Some rules test external services, as specified in the config file :   

 - the :data\_server is reachable (via http/https)
 - the mongoDB server responds, and the database exits

Some rules test the file system, as specified in the config file :   

 - an :upload\_location directory exists
 - a :nda\_pdf file exists

## How to use

Early in your project boot sequence, insert tests scripts like this :


    require 'fail_fast'
  
    FailFast("path_to/config.yml").check do

      # ensure non-blank values are specified :
      has_value_for :application_name
      has_values_for 'author/fname', 'author/lname'

      # ensure the value matches a regexp :
      has_value_for   'level',  /(alpha|beta|production)/


      # ensure the value is a valid - and reachable - url :
      has_url_for 'bug_tracker/url', :reachable => true, :may_add_trailing_slash => true

      # ensure the value is a valid email address :
      has_email_for 'newsletter/to_address'

      # ensure the mongoDB server can be reached, and the db could be opened :
      has_mongoDB_for 'test/mongoDB'
      # just ensure the mongoDB server can be reached :
      has_mongoDB_for 'test/unknown_mongoDB_db', :check_database => false

      # test an active_record connection
      has_active_record_db_for 'production/db_connection'

      directory_exists_for  'public/assets'
      file_exists_for       'public/500_custom.html'
    end

You can also test values in direct mode (specify the value, instead of obtaining it from the config file)

      directory_exists  '/tmp'
      file_exists       '/Users/me/.bash_profile'

      has_mongoDB           'localhost', 'db_app_1'
      has_active_record_db  :host => 'localhost', :adapter => 'mysql', :database=> 'a-db', :username => 'root'


You can also specify a key prefix :

    prefix = Rails.env
    FailFast.config_file('database.yml', prefix).fail_fast do
      has_values_for :database, :host, :port
    end

