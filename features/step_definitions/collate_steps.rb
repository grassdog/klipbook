require 'pry'

CLIPPING_FILE = File.join(File.dirname(__FILE__), '../fixtures/clippings-for-three-books.txt')

Given /^a file that contains clippings for 3 books called "([^"]*)"$/ do |file_name|
  in_current_dir { FileUtils.cp(CLIPPING_FILE, file_name) }
end

When /^I collate clippings for "([^"]*)" books from the file "([^"]*)" to the output directory "([^"]*)"$/ do |book_count, input_file, output_dir|
  run_simple(unescape("klipbook -n #{book_count} collate -o #{output_dir} file:#{input_file}"))
end

Then /^I should find a file in the folder "([^"]*)" named "([^"]*)" that contains "([^"]*)" clippings$/ do |output_folder, file_name, clipping_count|
  in_current_dir do
    file_path = File.join(output_folder, file_name)
    File.exists?(file_path).should be_true
    File.open(file_path, 'r') do |f|
      f.read.should match(/<footer>\s+#{clipping_count} clippings &bull;/m)
    end
  end
end

# FIXME This step currently assumes you have site: set up in your klipbookrc
When /^I collate clippings for "([^"]*)" books from the kindle site to the output directory "([^"]*)"$/ do |book_count, output_dir|
  run_simple(unescape("klipbook -n #{book_count} collate -o #{output_dir}"))
end

Then /^I should find "([^"]*)" collated files in the directory "([^"]*)" that contains clippings$/ do |file_count, output_dir|
  in_current_dir do
    files = Dir['*.html']
    files.should have(file_count.to_i).items

    files.each do |file|
      file_path = File.join(output_dir, file)
      File.open(file_path, 'r') do |f|
        f.read.should match(/<footer>\s+\d+ clippings &bull;/m)
      end
    end
  end
end


