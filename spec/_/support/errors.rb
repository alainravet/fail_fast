
def produce_1_error_in_1_check_block
  FailFast(EMPTY_FILE_PATH).check.but_fail_later do
    is_on_path("azertyuiop")
  end
end

def produce_2_errors_in_1_check_block
  FailFast(SIMPLE_FILE_PATH).check.but_fail_later do
    has_value_for(:anykey_1, :message => 'msg-A')
    has_value_for(:anykey_2, :message => 'msg-B')
  end
end
