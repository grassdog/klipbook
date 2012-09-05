module Klipbook
  class Collator
    def initialize(books, summary_writer=Klipbook::Output::HtmlSummaryWriter.new)
      @books = books
      @summary_writer = summary_writer
    end

    def collate_books(output_dir, force, message_stream=$stdout)
      message_stream.puts "Using output directory: #{output_dir}"

      @books.each do |book|
        @summary_writer.write(book, output_dir, force)
      end
    end
  end
end

