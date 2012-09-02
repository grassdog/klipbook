require 'erb'

module Klipbook::Output
  class HtmlSummaryWriter
    def initialize(message_stream=$stderr)
      @message_stream = message_stream
    end

    def write(book, output_dir, force)
      book.extend Klipbook::Output::BookHelpers

      filename = create_file_name(book, output_dir)

      if !force && File.exists?(filename)
        @message_stream.puts("Skipping existing summary file: #{filename}")
        return
      end

      @message_stream.puts("Writing html summary file: #{filename}")
      File.open(filename, 'w') do |f|
        f.write generate_html(book)
      end
    end

    private

    def create_file_name(book, output_dir)
      File.join(output_dir, "#{book.title} by #{book.author}.html")
    end

    def generate_html(book)
      ERB.new(template, 0, '%<>').result(book.get_binding)
    end

    # TODO Add mixin that provides location links

    def template
      @template ||= File.read(File.join(File.dirname(__FILE__), 'html_book_summary.erb'))
    end
  end
end
