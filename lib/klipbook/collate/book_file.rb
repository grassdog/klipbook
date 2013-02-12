require 'json'

module Klipbook::Collate
  class BookFile
    attr_reader :books

    def initialize(books)
      @books = books || []
    end

    def add_books(new_books)
      @books.concat(new_books)
    end

    def to_json
      JSON.pretty_generate(@books)
    end
  end
end
