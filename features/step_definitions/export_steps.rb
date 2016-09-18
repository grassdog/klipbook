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

When(/^I export clippings for "([^"]*)" books from the file "([^"]*)" as "([^"]*)" to the output directory "([^"]*)"$/) do |book_count, input_file, format, output_dir|
  run_export_file(book_count, output_dir, input_file, format, false)
end

When(/^I export clippings for "([^"]*)" books from the file "([^"]*)" as "([^"]*)" to the output directory "([^"]*)" forcefully$/) do |book_count, input_file, format, output_dir|
  run_export_file(book_count, output_dir, input_file, format, true)
end

Then(/^I should find a "([^"]*)" file in the folder "([^"]*)" named "([^"]*)" that contains "([^"]*)" clippings$/) do |format, output_folder, file_name, clipping_count|
  cd('.') do
    file_path = File.join(output_folder, file_name)
    expect(File.exist?(file_path)).to be_truthy
    File.open(file_path, 'r') do |f|
      if format == 'html'
        expect(f.read).to match(/<footer>\s+#{clipping_count} clippings &bull;/m)
      elsif format == 'markdown'
        clippings = f.readlines.slice(5..-1).join.split("\n\n\n")
        expect(clippings.count).to eq Integer(clipping_count)
      end
    end
  end
end

Then(/^the exit status should be non\-zero$/) do
  expect(last_command_started).not_to be_successfully_executed
end

# This step currently assumes you have site: set up in your klipbookrc
# TODO Add a hook to inject VCR or similar here
When(/^I export clippings for "([^"]*)" books from the kindle site as "([^"]*)" to the output directory "([^"]*)"$/) do |book_count, format, output_dir|
  run_simple(sanitize_text("klipbook tohtml -n #{book_count} -o #{output_dir}"), false)
end

Then(/^I should find "([^"]*)" "([^"]*)" files containing clippings in the directory "([^"]*)"$/) do |file_count, format, output_dir|
  format = "md" if format == "markdown"

  cd('.') do
    files = Dir["#{output_dir}/*.#{format}"]
    expect(files.size).to eq(file_count.to_i)
    # files.each do |fname|
    #   File.open(fname, 'r') do |f|
    #     expect(f.read).to match(/<footer>\s+\d+ clippings &bull;/m)
    #   end
    # end
  end
end

def run_export_file(book_count, output_dir, input_file, format, force=false)
  force_str = force ? '-f' : ''

  if format == 'html'
    run_simple(sanitize_text("klipbook tohtml -n #{book_count} #{force_str} -o #{output_dir} -i #{input_file}"), false)
  elsif format == 'markdown'
    run_simple(sanitize_text("klipbook tomarkdown -n #{book_count} #{force_str} -o #{output_dir} -i #{input_file}"), false)
  else
    run_simple(sanitize_text("klipbook export -n #{book_count} #{force_str} -o #{output_dir} -i #{input_file}"), false)
  end
end
