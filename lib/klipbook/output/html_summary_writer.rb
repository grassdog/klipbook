require 'erb'

module Klipbook::Output
  class HtmlSummaryWriter
    def initialize(output_dir, message_stream=$stderr)
      @output_dir = output_dir
      @message_stream = message_stream
    end

    def write(book, force)
      filename = create_file_name(book)

      if !force && File.exists?(filename)
        @message_stream.puts("Skipping existing summary file: #{filename}")
        return
      end

      File.open(create_file_name(book), 'w') do |f|
        f.write generate_html(book)
      end
    end

    private

    def create_file_name(book)
      File.join(@output_dir, "#{book.title} by #{book.author}.html")
    end

    def generate_html(book, options={})
      include_pages = options[:include_pages]
      ERB.new(template, 0, '%<>').result(book.get_binding)
    end

    def template
      @template ||= File.read(File.join(File.dirname(__FILE__), 'html_book_summary.erb'))
    end
  end
end
