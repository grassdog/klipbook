
When /^I tojson clippings for "([^"]*)" books from the file "([^"]*)" to the output file "([^"]*)"$/ do |book_count, input_file, output_file|
  run_tojson(book_count, output_file, input_file)
end

Then /^I should find a file called "([^"]*)" that contains "([^"]*)"$/ do |output_file, expected_text|
  cd('.') do
    expect(File.exists?(output_file)).to be_truthy
    File.open(output_file, 'r') do |f|
      expect(f.read).to match(/#{expected_text}/m)
    end
  end
end

def run_tojson(book_count, output_file, input_file)
  run_simple(sanitize_text("klipbook tojson -n #{book_count} -o #{output_file} -i #{input_file}"), false)
end
