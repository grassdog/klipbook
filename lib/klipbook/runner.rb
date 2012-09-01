module Klipbook
  class Runner
    def initialize(book_source)
      @book_source = book_source
    end

    def summarise_all_books(output_dir, force)

    end

    def list_books(output=$stdout)
      if @book_source.books.empty?
        output.puts 'Your clippings file contains no books'
      else
        output.puts 'The list of books in your clippings file:'
        @book_source.books.each_with_index do |book, index|
          author = book.author ? " by #{book.author}" : ''
          output.puts "[#{index + 1}] #{book.title}#{author}"
        end
      end
    end

    def print_book_summary(book_number, output, options={})
      if book_number < 1 or book_number > @book_source.books.length
        $stderr.puts "Sorry but you must specify a book index between 1 and #{@book_source.books.length}"
        return
      end

      # TODO Override this guy to do the right thing for files
      book_summary = @book_source.books[book_number - 1]
      output.write book_summary.as_html(options)
    end
  end
end
