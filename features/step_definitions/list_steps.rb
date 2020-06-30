
Given /^I have a clippings file "([^"]*)" that contains no clippings$/ do |input_file|
  cd('.') do
    FileUtils.touch(input_file)
  end
end

When /^I list "([^"]*)" books in the file "([^"]*)"$/ do |book_count, input_file|
  run_command_and_stop(sanitize_text("klipbook list -c #{book_count} --from-file #{input_file}"), fail_on_error: false)
end

