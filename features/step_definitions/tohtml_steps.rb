CLIPPING_FILE = File.join(File.dirname(__FILE__), '../fixtures/clippings-for-three-books.txt')

Given /^a file in "([^"]*)" named "([^"]*)"$/ do |output_dir, file_name|
  cd('.') { FileUtils.touch(File.join(output_dir, file_name)) }
end

Given /^there is not a directory named "([^"]*)"$/ do |directory_name|
  cd('.') do
    FileUtils.rm_f(directory_name)
  end
end

Given /^a file that contains clippings for 3 books called "([^"]*)"$/ do |file_name|
  cd('.') { FileUtils.cp(CLIPPING_FILE, file_name) }
end

When /^I tohtml clippings for "([^"]*)" books from the file "([^"]*)" to the output directory "([^"]*)"$/ do |book_count, input_file, output_dir|
  run_tohtml_file(book_count, output_dir, input_file, false)
end

When /^I tohtml clippings for "([^"]*)" books from the file "([^"]*)" to the output directory "([^"]*)" forcefully$/ do |book_count, input_file, output_dir|
  run_tohtml_file(book_count, output_dir, input_file, true)
end

Then /^I should find a file in the folder "([^"]*)" named "([^"]*)" that contains "([^"]*)" clippings$/ do |output_folder, file_name, clipping_count|
  cd('.') do
    file_path = File.join(output_folder, file_name)
    expect(File.exists?(file_path)).to be_truthy
    File.open(file_path, 'r') do |f|
      expect(f.read).to match(/<footer>\s+#{clipping_count} clippings &bull;/m)
    end
  end
end

# FIXME This step currently assumes you have site: set up in your klipbookrc
When /^I tohtml clippings for "([^"]*)" books from the kindle site to the output directory "([^"]*)"$/ do |book_count, output_dir|
  run_simple(sanitize_text("klipbook tohtml -n #{book_count} -o #{output_dir}"), false)
end

Then /^I should find "([^"]*)" html files containing clippings in the directory "([^"]*)"$/ do |file_count, output_dir|
  cd('.') do
    files = Dir['output/*.html']
    expect(files.size).to eq(file_count.to_i)
    files.each do |fname|
      File.open(fname, 'r') do |f|
        expect(f.read).to match(/<footer>\s+\d+ clippings &bull;/m)
      end
    end
  end
end

def run_tohtml_file(book_count, output, input, force=false)
  force_str = if force
    '-f'
  else
    ''
  end

  run_simple(sanitize_text("klipbook tohtml -n #{book_count} #{force_str} -o #{output} -i #{input}"), false)
end

