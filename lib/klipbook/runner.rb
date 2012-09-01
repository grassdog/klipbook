module Klipbook
  class Runner
    def initialize(input_file)
      @file = Klipbook::Sources::KindleDevice::File.new(input_file.read.strip)
    end

    def list_books(output=$stdout)
      if @file.books.empty?
        output.puts 'Your clippings file contains no books'
      else
        output.puts 'The list of books in your clippings file:'
        @file.books.each_with_index do |book, index|
          author = book.author ? " by #{book.author}" : ''
          output.puts "[#{index + 1}] #{book.title}#{author}"
        end
      end
    end

    def print_book_summary(book_number, output, options={})
      if book_number < 1 or book_number > @file.books.length
        $stderr.puts "Sorry but you must specify a book index between 1 and #{@file.books.length}"
        return
      end

      # TODO Override this guy to do the right thing for files
      book_summary = @file.books[book_number - 1]
      output.write book_summary.as_html(options)
    end
  end
end
