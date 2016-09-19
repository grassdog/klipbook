module Klipbook
  module Commands
    module Exporters
      class MarkdownExporter < Exporter
        def render_contents(book)
          ERB.new(template, 0, '%<>').result(book.get_binding)
        end

        def extension
          "md"
        end

        def template
          @template ||= File.read(File.join(File.dirname(__FILE__), 'markdown_book_summary.erb'))
        end
      end
    end
  end
end
