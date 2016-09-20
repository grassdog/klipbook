module Klipbook
  module Commands
    class Export < Command
      def run_command!(book_source, options)
        exit_unless_valid_format(options)
        exit_unless_valid_output_dir(options)

        exporter(options).run!(
          books: book_source.books,
          force: options.force,
          output_dir: options.output_dir
        )
      end

      private

      def exporter(options)
        case options.format
        when  "markdown"
          Exporters::MarkdownExporter.new(logger)
        when "html"
          Exporters::HTMLExporter.new(logger)
        when "json"
          Exporters::JSONExporter.new(logger)
        else
          raise "Unexpected format"
        end
      end

      def exit_unless_valid_format(options)
        unless ["markdown", "html", "json"].include?(options.format)
          logger.error "Error: You must specify a valid format."
          exit 127
        end
      end

      def exit_unless_valid_output_dir(options)
        unless options.output_dir
          logger.error "Error: Please specify an outdir."
          exit 127
        end

        unless File.directory?(options.output_dir)
          logger.error "Error: Output directory '#{options.output_dir}' does not exist."
          exit 127
        end
      end
    end
  end
end
