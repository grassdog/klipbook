module Klipbook::Commands
  class ListBooks
    def initialize(books)
      @books = books
    end

    def call(output_stream=$stdout)
      if @books.empty?
        output_stream.puts 'No books available'
      else
        output_stream.puts 'Book list:'
        @books.each_with_index do |book, index|
          output_stream.puts "[#{index + 1}] #{book.title_and_author}"
        end
      end
    end
  end
end

