module Klipbook
  class ClippingsFile
    attr_accessor :books

    def initialize(file_text, parser=Klipbook::ClippingsParser.new)
      @books = extract_books_from_file_text(parser, file_text)
    end

   private

    def extract_books_from_file_text(parser, file_text)
      clippings = parser.extract_clippings_from(file_text)

      group_clippings_into_books(clippings)
    end

    def group_clippings_into_books(clippings)
      books = clippings.inject({}) do |new_hash, clipping|
        new_hash[hash_key_for_book(clipping)] ||= []
        new_hash[hash_key_for_book(clipping)] << clipping
        new_hash
      end

      books = sort_books_by_title(books)
      books = sort_clippings_by_location(books)
      build_book_summaries(books)
    end

    def build_book_summaries(books)
      books.values.map { |clippings| Klipbook::BookSummary.new(clippings.first.title, clippings.first.author, clippings) }
    end

    def hash_key_for_book(clipping)
      "#{clipping.title}#{clipping.author}"
    end

    def sort_books_by_title(books)
      Hash[books.sort]
    end

    def sort_clippings_by_location(books)
      books.inject({}) do |new_hash, (k, v)|
        new_hash[k] = v.sort
        new_hash
      end
    end
  end
end


