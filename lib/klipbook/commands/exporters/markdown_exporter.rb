# coding: utf-8
module Klipbook
  module Commands
    module Exporters
      class MarkdownExporter < Exporter
        def render_contents(book)
          result = "# #{book.title}\n\n"
          result << "*by #{book.author}*\n\n\n"

          book.clippings.each do |clipping|
            text = clipping.text
            hl_url = clipping.location ? "[∞](kindle://book?action=open&asin=#{book.asin}&location=#{clipping.location})" : ""

            result << "#{text.strip} #{hl_url}\n\n\n"
          end

          result
        end

        def extension
          "md"
        end
      end
    end
  end
end
