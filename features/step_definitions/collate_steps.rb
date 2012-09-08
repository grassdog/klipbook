CLIPPING_FILE = File.join(File.dirname(__FILE__), '../fixtures/clippings-for-three-books.txt')

Given /^a file in "([^"]*)" named "([^"]*)"$/ do |output_dir, file_name|
  in_current_dir { FileUtils.touch(File.join(output_dir, file_name)) }
end

Given /^there is not a directory named "([^"]*)"$/ do |directory_name|
  in_current_dir do
    FileUtils.rm_f(directory_name)
  end
end

Given /^a file that contains clippings for 3 books called "([^"]*)"$/ do |file_name|
  in_current_dir { FileUtils.cp(CLIPPING_FILE, file_name) }
end

When /^I collate clippings for "([^"]*)" books from the file "([^"]*)" to the output directory "([^"]*)"$/ do |book_count, input_file, output_dir|
  run_collate_file(book_count, output_dir, input_file, false)
end

When /^I collate clippings for "([^"]*)" books from the file "([^"]*)" to the output directory "([^"]*)" forcefully$/ do |book_count, input_file, output_dir|
  run_collate_file(book_count, output_dir, input_file, true)
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
  run_simple(unescape("klipbook -n #{book_count} collate -o #{output_dir}"), false)
end

Then /^I should find "([^"]*)" collated files containing clippings in the directory "([^"]*)"$/ do |file_count, output_dir|
  in_current_dir do
    files = Dir['output/*.html']
    files.should have(file_count.to_i).items
    files.each do |fname|
      File.open(fname, 'r') do |f|
        f.read.should match(/<footer>\s+\d+ clippings &bull;/m)
      end
    end
  end
end

def run_collate_file(book_count, output, input, force=false)
  force_str = if force
    '-f'
  else
    ''
  end

  run_simple(unescape("klipbook -n #{book_count} collate #{force_str} -o #{output} file:#{input}"), false)
end

