require 'json'

module Klipbook::Collate
  class BookFile
    attr_reader :books

    def self.from_json(raw_json)
      if raw_json.blank?
        books = []
      else
        objs = JSON.parse(raw_json)
        books = objs.map { |o| Klipbook::Book.from_hash(o) }
      end
      self.new(books)
    end

    def initialize(books)
      @books = books || []
    end

    def add_books(new_books, force, message_stream=$stdout)
      new_books.each do |new_book|
        if book_exists?(new_book)
          replace_book(new_book, message_stream) if force
        else
          message_stream.puts "Adding: #{new_book.title_and_author}"
          @books.push(new_book)
        end
      end
    end

    def to_json
      JSON.pretty_generate(@books)
    end

    private

    def book_exists?(new_book)
      find_book(new_book)
    end

    def find_book(new_book)
      @books.find { |existing_book| existing_book.title_and_author == new_book.title_and_author }
    end

    def replace_book(new_book, message_stream)
      message_stream.puts "Updating: #{new_book.title_and_author}"

      old_book = find_book(new_book)
      @books.delete(old_book)
      @books.push(new_book)
    end
  end
end
