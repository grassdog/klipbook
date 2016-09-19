module Klipbook
  module Commands
    module Exporters
      class HTMLExporter < Exporter
        def initialize(pretty_printer=Html::Printer.new, logger=Logger.new)
          super(logger)
          @pretty_printer = pretty_printer
        end

        def render_contents(book)
          ERB.new(template, 0, '%<>').result(book.get_binding)
        end

        def extension
          "html"
        end

        def template
          @template ||= File.read(File.join(File.dirname(__FILE__), 'html_book_summary.erb'))
        end
      end
    end
  end
end

