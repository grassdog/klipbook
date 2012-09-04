module Klipbook
  class Summariser
    def initialize(book_source, summary_writer=Klipbook::Output::HtmlSummaryWriter.new)
      @book_source = book_source
      @summary_writer = summary_writer
    end

    def summarise_all_books(output_dir, force, message_stream=$stdout)
      message_stream.puts "Using output directory: #{output_dir}"

      @book_source.books.each do |book|
        @summary_writer.write(book, output_dir, force)
      end
    end

    def summarise_book(book_index, output_dir, force)
      unless book_index < @book_source.books.count
        raise "Invalid book. Please specify a number between 1 and #{@book_source.books.count}."
      end

      book = @book_source.books.fetch(book_index)
      @summary_writer.write(book, output_dir, force)
    end
  end
end

