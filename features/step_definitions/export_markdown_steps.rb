
# FIXME This step currently assumes you have site: set up in your klipbookrc
When /^I tomarkdown clippings for "([^"]*)" books from the kindle site to the output directory "([^"]*)"$/ do |book_count, output_dir|
  run_simple(sanitize_text("klipbook tomarkdown -n #{book_count} -o #{output_dir}"), false)
end


def run_tomarkdown_file(book_count, output, input, force=false)
  force_str = if force
    '-f'
  else
    ''
  end

  run_simple(sanitize_text("klipbook tomarkdown -n #{book_count} #{force_str} -o #{output} -i #{input}"), false)
end

