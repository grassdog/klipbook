module Klipbook
  class Lister
    def initialize(book_source)
      @book_source = book_source
    end

    def list_books(output=$stdout)
      if @book_source.books.empty?
        output.puts 'No books available'
      else
        output.puts 'Book list:'
        @book_source.books.each_with_index do |book, index|
          output.puts "[#{index + 1}] #{book.title_and_author}"
        end
      end
    end
  end
end
