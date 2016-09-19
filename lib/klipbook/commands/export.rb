module Klipbook
  module Commands
    class Export < Command
      def run_command!(book_source, options)
        exit_unless_valid_format(options)


        # Pass it to run protected method
      end

      private

      def exit_unless_valid_format(options)
        unless ["markdown", "html", "json"].include?(options.format)
          logger.error "Error: You must specify a valid format."
          exit 127
        end
      end
    end
  end
end
