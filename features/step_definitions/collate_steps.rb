
When /^I collate clippings for "([^"]*)" books from the file "([^"]*)" to the output file "([^"]*)"$/ do |book_count, input_file, output_file|
  run_collate(book_count, output_file, input_file)
end

Then /^I should find a file called "([^"]*)" that contains "([^"]*)"$/ do |output_file, expected_text|
  in_current_dir do
    File.exists?(output_file).should be_true
    File.open(output_file, 'r') do |f|
      f.read.should match(/#{expected_text}/m)
    end
  end
end

def run_collate(book_count, output_file, input_file)
  run_simple(unescape("klipbook -n #{book_count} collate -c #{output_file} file:#{input_file}"), false)
end
