require 'json'

module Klipbook
  module Commands
    module Exporters
      class JSONExporter < Exporter
        def render_contents(book)
          JSON.pretty_generate(book)
        end

        def extension
          "json"
        end
      end
    end
  end
end
