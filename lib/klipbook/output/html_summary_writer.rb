require 'erb'

module Klipbook::Output
  class HtmlSummaryWriter
    def initialize(message_stream=$stderr)
      @message_stream = message_stream
    end

    def write(book, output_dir, force)
      require 'rainbow'

      book.extend Klipbook::Output::BookHelpers

      filename = filename_for_book(book)
      filepath = File.join(output_dir, filename)

      if !force && File.exists?(filepath)
        @message_stream.puts("Skipping ".foreground(:yellow) + filename)
        return
      end

      @message_stream.puts("Writing ".foreground(:green) + filename)
      File.open(filepath, 'w') do |f|
        f.write generate_html(book)
      end
    end

    private

    def filename_for_book(book)
      unless book.author.blank?
        author = " by #{book.author}"
      else
        author = ''
      end

      "#{book.title}#{author}.html"
    end

    def generate_html(book)
      ERB.new(template, 0, '%<>').result(book.get_binding)
    end

    def template
      @template ||= File.read(File.join(File.dirname(__FILE__), 'html_book_summary.erb'))
    end
  end
end
