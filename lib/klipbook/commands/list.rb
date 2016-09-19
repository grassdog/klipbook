module Klipbook
  module Commands
    class List < Command
      def run_command!(book_source, _options)
        books = book_source.books
        if books.empty?
          logger.info 'No books available'
        else
          logger.info 'Book list:'
          books.each_with_index do |book, index|
            logger.info "[#{index + 1}] #{book.title_and_author}"
          end
        end
      end
    end
  end
end
