require 'fail_fast/main'

require 'fail_fast/check_value'
require 'fail_fast/check_file_system'
require 'fail_fast/check_mongo_db'
require 'fail_fast/check_active_record_db'
require 'fail_fast/check_url'
require 'fail_fast/check_email'


def FailFast(path, prefix=nil)
  FailFast.new(path, prefix)
end

