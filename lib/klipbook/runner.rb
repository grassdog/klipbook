module Klipbook
  class Runner
    def initialize(input_file)
      @clippings_file = Klipbook::ClippingsFile.new(input_file.read.strip)
    end

    def list_books(output=$stdout)
      if @clippings_file.books.empty?
        output.puts 'Your clippings file contains no books'
      else
        output.puts 'The list of books in your clippings file:'
        @clippings_file.books.each_with_index do |book, index|
          author = book.author ? " by #{book.author}" : ''
          output.puts "[#{index + 1}] #{book.title}#{author}"
        end
      end
    end

    def print_book_summary(book_number, output, options={})
      if book_number < 1 or book_number > @clippings_file.books.length
        $stderr.puts "Sorry but you must specify a book index between 1 and #{@clippings_file.books.length}"
        return
      end

      book_summary = @clippings_file.books[book_number - 1]
      output.write book_summary.as_html(options)
    end
  end
end
