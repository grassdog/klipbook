CLIPPING_FILE = File.join(
  File.dirname(__FILE__),
  '../fixtures/clippings-for-three-books.txt'
)

Given(/^a file in "([^"]*)" named "([^"]*)"$/) do |output_dir, file_name|
  cd('.') { FileUtils.touch(File.join(output_dir, file_name)) }
end

Given(/^there is not a directory named "([^"]*)"$/) do |directory_name|
  cd('.') { FileUtils.rm_f(directory_name) }
end

Given(/^a file that contains clippings for 3 books called "([^"]*)"$/) do |file_name|
  cd('.') { FileUtils.cp(CLIPPING_FILE, file_name) }
end

#
# Whens
#

When(/^I export clippings for "([^"]*)" books from the file "([^"]*)" as "([^"]*)" to the output directory "([^"]*)"$/) do |book_count, input_file, format, output_dir|
  run_export_file(book_count, output_dir, input_file, format, false)
end

When(/^I export clippings for "([^"]*)" books from the file "([^"]*)" as "([^"]*)" to the output directory "([^"]*)" forcefully$/) do |book_count, input_file, format, output_dir|
  run_export_file(book_count, output_dir, input_file, format, true)
end


#
# Thens
#

Then(/^I should find a "([^"]*)" file in the folder "([^"]*)" named "([^"]*)" that contains "([^"]*)" clippings$/) do |format, output_folder, file_name, clipping_count|
  cd('.') do
    file_path = File.join(output_folder, file_name)
    expect(File.exist?(file_path)).to be_truthy
    File.open(file_path, 'r') do |f|
      confirm_clipping_count(f, format, clipping_count)
    end
  end
end

Then(/^the exit status should be non\-zero$/) do
  expect(last_command_started).not_to be_successfully_executed
end

Then(/^I should find "([^"]*)" "([^"]*)" files containing clippings in the directory "([^"]*)"$/) do |file_count, format, output_dir|
  extension = format == "markdown" ? "md" : format

  cd('.') do
    files = Dir["#{output_dir}/*.#{extension}"]
    expect(files.size).to eq(file_count.to_i)
    files.each do |fname|
      File.open(fname, 'r') do |f|
        confirm_clipping_exist(f, format)
      end
    end
  end
end

def run_export_file(book_count, output_dir, input_file, format, force=false)
  force_str = force ? '-f' : ''

  run_simple(sanitize_text("klipbook export --format #{format} -c #{book_count} #{force_str} --output-dir #{output_dir} --from-file #{input_file}"), false)
end



def confirm_clipping_count(file, format, expected_count)
  if format == 'html'
    expect(file.read).to match(/<footer>\s+#{expected_count} clippings &bull;/m)
  elsif format == 'markdown'
    clippings = file.readlines.slice(5..-1).join.split("\n  \n  \n")
    expect(clippings.count).to eq Integer(expected_count)
  elsif format == 'json'
    expect(JSON.parse(file.read)["clippings"].count).to eq Integer(expected_count)
  else
    raise "Unknown format"
  end
end

def confirm_clipping_exist(file, format)
  if format == 'html'
    expect(file.read).to match(/<footer>\s+\d+ clippings &bull;/m)
  elsif format == 'markdown'
    clippings = file.readlines.slice(5..-1).join.split("\n  \n  \n")
    expect(clippings.count).to be > 0
  elsif format == 'json'
    expect(JSON.parse(file.read)["clippings"].count).to be > 0
  else
    raise "Unknown format"
  end
end
