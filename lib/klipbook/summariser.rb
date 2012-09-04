module Klipbook
  class Summariser
    def initialize(books, summary_writer=Klipbook::Output::HtmlSummaryWriter.new)
      @books = books
      @summary_writer = summary_writer
    end

    def summarise_all_books(output_dir, force, message_stream=$stdout)
      message_stream.puts "Using output directory: #{output_dir}"

      @books.each do |book|
        @summary_writer.write(book, output_dir, force)
      end
    end

    # TODO This might go away
    def summarise_book(book_index, output_dir, force)
      unless book_index < @books.count
        raise "Invalid book. Please specify a number between 1 and #{@books.count}."
      end

      # TODO Not sure this should be fetch
      book = @books.fetch(book_index)
      @summary_writer.write(book, output_dir, force)
    end
  end
end

