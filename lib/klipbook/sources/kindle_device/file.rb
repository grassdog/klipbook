module Klipbook::Sources
  module KindleDevice
    class File
      def initialize(file_text, file_parser=FileParser.new, book_list=BookList.new)
        @file_text = file_text
        @file_parser = file_parser
        @book_list = book_list
      end

      def books
        sorted_entries = extract_sorted_entries
        build_sorted_book_list(sorted_entries)
      end

    private

      def extract_sorted_entries
        entries = @file_parser.extract_entries(@file_text)
        entries.sort { |entry_a, entry_b| entry_a.title <=> entry_b.title }
      end

      def build_sorted_book_list(sorted_entries)
        @book_list.from(sorted_entries).sort do |book_a, book_b|
          book_a.title <=> book_b.title
        end
      end
    end
  end
end
