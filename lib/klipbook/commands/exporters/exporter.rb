module Klipbook
  module Commands
    module Exporters
      class Exporter
        def initialize(logger=Logger.new)
          @logger = logger
        end

        def run!(books:, force:, output_dir:)
          @logger.info "Using output directory: #{output_dir}"

          books.each do |book|
            export_book(book, output_dir, force)
          end
        end

        private

        def export_book(book, output_dir, force)
          filename = filename_for_book(book)
          filepath = File.join(output_dir, filename)

          if !force && File.exist?(filepath)
            @logger.info "- Skipping #{filename}"
            return
          end

          @logger.info "+ Writing #{filename}"

          File.open(filepath, 'w') do |f|
            f.write render_contents(book)
          end
        end

        def render_contents(book)
          raise "Implement me"
        end

        def extension
          raise "Implement me"
        end

        def filename_for_book(book)
          "#{book.title.gsub(/[:,\/!?]/, "")}.#{extension}"
        end
      end
    end
  end
end
