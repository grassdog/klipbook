module Klipbook
  class Summariser
    def initialize(book_source, summary_writer=Klipbook::Output::HtmlSummaryWriter.new)
      @book_source = book_source
      @summary_writer = summary_writer
    end

    def summarise_all_books(output_dir, force, message_stream=$stderr)
      message_stream.puts "Output directory: #{output_dir}"

      @book_source.books.each do |book|
        @summary_writer.write(book, output_dir, force)
      end
    end

    def summarise_book(book_index, force)
      raise "Sorry there are only #{@book_source.books.count} books" unless book_index < @book_source.books.count

      book = @book_source.books.fetch(book_index)
      @summary_writer.write(book, force)
    end
  end
end

