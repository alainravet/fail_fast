require 'rubygems'
gem 'mongo', '1.0'
require 'mongo'

def fake_http_server
  require 'webmock'
  stub_request(:get, "http://example.com/index.html").to_return(:body => "I'm reachable!")
  stub_request(:get, "http://localhost/index.html"  ).to_return(:body => "I'm reachable!")
  stub_request(:get, "http://example.com"           ).to_return(:body => "I'm reachable!")
end
def fake_mongo_server_absent
  require 'mocha'
  Mongo::Connection.stubs(:new).raises(Mongo::ConnectionFailure)
end
def fake_mongo_db_absent
  require 'mocha'
  Mocha::Mockery.instance.stubba.unstub_all
  
  conn = Mongo::Connection.new
  conn.stubs(:database_names).returns []
  Mongo::Connection.stubs(:new).returns(conn)
end

$LOAD_PATH.unshift(File.dirname(__FILE__)+'/lib')
SPEC_DIR = File.dirname(__FILE__)+'/spec'

require 'fail_fast'


FailFast('unknown-file').check_now.but_fail_later do
end

FailFast().check_now.but_fail_later do
  fail '_why could not be found on the path' unless `which _why` =~ /_why$/
end

FailFast(SPEC_DIR + '/fixtures/simple.yml').check_now.but_fail_later do

#test values :
  has_value_for   :first_keyNOT , :message => 'this is a custom message' # single absent key
  has_values_for  :last_keyNOT, 'number_sixNOT'   # multiple absent keys
  has_value_for 'testNOT/mongoDB/database'        # invalid yaml path

  has_value_for :last_key, /(will_never_match)/   # value does not match regexp

  has_email_for 'test/host'                       # value is not an email address

  fake_http_server
  has_url_for 'test/host'                         # value is not a url

  nda_file = value_of(:nda_file)
  fail 'NDA is too old' if (Time.now - File.mtime(nda_file))  > (24 * 60 * 60) * 365

#test http server :
  has_url_for 'test/url_not_reachable', :reachable => true #server is not reachable

#test file system :
  directory_exists  '/foobarbaz'                  # not a directory
  directory_exists_for  'test/a_file'             # not a directory

  file_exists         '/tmp/foo/bar/??nOTaFile'   # not a file
  file_exists_for     'test/a_directory'          # not a file

  is_on_path '_why'
  is_on_path_for 'app_not_on_path'

#test mondoDB
  fake_mongo_server_absent
  has_mongoDB      '10.0.0.123', :timeout => 1    # no mongo server at this address
  has_mongoDB_for  'test/mongoDB'                 #    "   "   "   "   "   "   ""

  fake_mongo_db_absent
  has_mongoDB      'localhost', 'not_a_known_db'
  has_mongoDB_for 'test/unknown_mongoDB_db'       # a mongoDB, but the DB is unknown

#test ActiveRecord
  has_active_record_db      :host => 'localhost', :adapter => 'mysql', :database=> 'some-db'
  has_active_record_db_for  'db_connection'

#misc
  fail 'a custom failure message'

#handmade :
  fail 'zruby is not on the path' unless `which zruby` =~ /zruby$/

  nda_file = value_of(:nda_file)
  fail 'NDA is too old' if (Time.now - File.mtime(nda_file))  > (24 * 60 * 60) * 365

end

if FailFast.failed?
  puts "cannot start the application due to the problems mentioned above"
  FailFast.fail_now
end
