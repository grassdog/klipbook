Before do
  FileUtils.mkdir_p(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

After do
  Dir.chdir(TEST_DIR)
  FileUtils.rm_rf(TEST_DIR)
end

class Output
  def messages
    @messages ||= []
  end

  def puts(message)
    messages << message
  end

  def write(message)
    messages << message
  end
end

def output
  @output ||= Output.new
end

CLIPPING_FILE = 'test_clippings.txt'

Given /^I have a file that contains no clippings$/ do
  File.open(CLIPPING_FILE, 'w') do |f|
    f.write ''
  end
end

When /^I list the books in the file with klipbook$/ do
  File.open(CLIPPING_FILE, 'r') do |f|
    Klipbook::Runner.new(f).list_books(output)
  end
end

Then /^I should see the message "([^"]*)"$/ do |message|
  output.messages.should include(message)
end

Given /^I have a file that contains clippings for the book titled "([^"]*)"$/ do |book_title|
  File.open(CLIPPING_FILE, 'a') do |f|
    f.write <<EOF
#{book_title}
- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM

A test highlight
==========
EOF
  end
end

Given /^I have a file that contains multiple clippings for the book titled "([^"]*)"$/ do |book_title|
  File.open(CLIPPING_FILE, 'a') do |f|
    f.write <<EOF
#{book_title}
- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM

A test highlight
==========
#{book_title}
- Highlight Loc. 490  | Added on Thursday, April 21, 2011, 07:36 AM

A second highlight
==========
EOF
  end
end

When /^I print the summary for book number "([^"]+)" with klipbook/ do |book_number|
  book_number = book_number.to_i

  File.open(CLIPPING_FILE, 'r') do |f|
    Klipbook::Runner.new(f).print_book_summary(book_number, output)
  end
end

Then /^I should see a pretty summary for the book "([^"]*)"$/ do |book_title|
  output.messages.first.should include("<h1>#{book_title}</h1")
end

