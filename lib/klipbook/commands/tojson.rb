module Klipbook::Commands
  class ToJson
    def initialize(books, book_file)
      @books = books
      @book_file = book_file
    end

    def call(output_file_path, force, message_stream=$stdout)
      File.open(output_file_path, 'w') do |output_file|
        @book_file.add_books(@books, force)

        message_stream.puts "\nWriting book json to file: #{output_file.path}"
        output_file.puts @book_file.to_json
      end
    end
  end
end
