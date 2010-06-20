def fake_the_remote_services
  require 'rubygems'
  require 'fakeweb'
  require 'mongo'
  require 'mocha'
  FakeWeb.register_uri(:get, "http://example.com/index.html", :body => "I'm reachable!")
  FakeWeb.register_uri(:get, "http://localhost/index.html", :body => "I'm reachable!")
  FakeWeb.register_uri(:get, "http://example.com", :body => "I'm reachable!")

  conn = Mongo::Connection.new
  conn.stubs(:database_names).returns %w(sample_mongoDB)
  Mongo::Connection.stubs(:new).returns(conn)
end
fake_the_remote_services

$LOAD_PATH.unshift(File.dirname(__FILE__)+'/lib')
SPEC_DIR = File.dirname(__FILE__)+'/spec'

require 'fail_fast'
FailFast(SPEC_DIR + '/fixtures/simple.yml').check do

#keyed mode
  has_value_for   :first_keyNOT                   # single absent key
  has_values_for  :last_keyNOT, 'number_sixNOT'   # multiple absent keys
  has_value_for 'testNOT/mongoDB/database'        # invalid yaml path

  has_email_for 'test/host'                       # value is not an email address
  has_url_for 'test/host'                         # value is not a url
  has_value_for :last_key, /(will_never_match)/   # value does not match regexp
  has_url_for 'test/url_not_reachable', :reachable => true #server is not reachable

  has_mongoDB_for 'test/email'                    # not a mongoDB server
  has_mongoDB_for 'test/unknown_mongoDB_db'       # a mongoDB, but the DB is unknown

  directory_exists_for  'test/a_file'             # not a directory
  file_exists_for       'test/a_directory'        # not a file

# direct mode
  directory_exists  '/foobarbaz'                  # not a directory
  file_exists       '/tmp/foo/bar/??nOTaFile'     # not a file
end
