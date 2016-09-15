module Klipbook::Commands
  class ToMarkdown
    def initialize(books)
      @books = books
    end

    def call(output_dir, force, message_stream=$stdout)
      message_stream.puts "Using output directory: #{output_dir}"

      @books.each do |book|
        mf = MarkdownFile.new(book)
        mf.save(output_dir, force)
      end
    end
  end
end

