# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fail_fast}
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alain Ravet"]
  s.date = %q{2010-07-29}
  s.description = %q{raises an error if the yaml contents of a config file does not pass a test script.}
  s.email = %q{alainravet@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "CHANGELOG.txt",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "fail_fast.gemspec",
     "lib/fail_fast.rb",
     "lib/fail_fast/base/base.rb",
     "lib/fail_fast/base/messaging.rb",
     "lib/fail_fast/base/utils.rb",
     "lib/fail_fast/base/z_only_for_tests.rb",
     "lib/fail_fast/extensions/base_commands.rb",
     "lib/fail_fast/extensions/check_active_record_db.rb",
     "lib/fail_fast/extensions/check_email.rb",
     "lib/fail_fast/extensions/check_file_system.rb",
     "lib/fail_fast/extensions/check_is_on_path.rb",
     "lib/fail_fast/extensions/check_mongo_db.rb",
     "lib/fail_fast/extensions/check_url.rb",
     "lib/fail_fast/extensions/check_value.rb",
     "lib/fail_fast/main.rb",
     "lib/fail_fast/report.txt.erb",
     "lib/fail_fast/support/error_db.rb",
     "lib/fail_fast/support/error_details.rb",
     "lib/fail_fast/support/z_only_for_tests.rb",
     "show_all_errors.rb",
     "spec/base/base_commands_spec.rb",
     "spec/base/error_details_spec.rb",
     "spec/base/errors_storage_spec.rb",
     "spec/base/file_is_empty_spec.rb",
     "spec/base/file_is_missing_spec.rb",
     "spec/base/multiple_blocks_support_spec.rb",
     "spec/base/not_linked_to_a_file_spec.rb",
     "spec/base/report_printing_spec.rb",
     "spec/extensions/check_active_record_db_spec.rb",
     "spec/extensions/check_email_spec.rb",
     "spec/extensions/check_file_system_spec.rb",
     "spec/extensions/check_is_on_path_spec.rb",
     "spec/extensions/check_mongo_db_spec.rb",
     "spec/extensions/check_url_spec.rb",
     "spec/extensions/check_value_spec.rb",
     "spec/extensions/key_prefix_spec.rb",
     "spec/fixtures/empty.yml",
     "spec/fixtures/simple.yml",
     "spec/how_to_use_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/alainravet/fail_fast}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{raises an error if the yaml contents of a config file does pass a test script.}
  s.test_files = [
    "spec/base/base_commands_spec.rb",
     "spec/base/error_details_spec.rb",
     "spec/base/errors_storage_spec.rb",
     "spec/base/file_is_empty_spec.rb",
     "spec/base/file_is_missing_spec.rb",
     "spec/base/multiple_blocks_support_spec.rb",
     "spec/base/not_linked_to_a_file_spec.rb",
     "spec/base/report_printing_spec.rb",
     "spec/extensions/check_active_record_db_spec.rb",
     "spec/extensions/check_email_spec.rb",
     "spec/extensions/check_file_system_spec.rb",
     "spec/extensions/check_is_on_path_spec.rb",
     "spec/extensions/check_mongo_db_spec.rb",
     "spec/extensions/check_url_spec.rb",
     "spec/extensions/check_value_spec.rb",
     "spec/extensions/key_prefix_spec.rb",
     "spec/how_to_use_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<mongo>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<mongo>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<mongo>, [">= 0"])
  end
end

