module Klipbook
  class Lister
    def initialize(books)
      @books = books
    end

    def list_books(output=$stdout)
      if @books.empty?
        output.puts 'No books available'
      else
        output.puts 'Book list:'
        @books.each_with_index do |book, index|
          output.puts "[#{index + 1}] #{book.title_and_author}"
        end
      end
    end
  end
end
