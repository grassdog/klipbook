module Klipbook
  module Commands
    class Command
      def initialize(logger=Logger.new)
        @logger = logger
      end

      def run!(options)
        run_command!(book_source(options), options)
      end

      def run_command!
        raise "Implement me"
      end

      private

      attr_reader :logger

      def book_source(options)
        Klipbook::Sources::Source.build(options)
      end

      def exit_unless_valid_source(options)
        unless options.from_file || options.from_site
          logger.error "Error: You must specify either `--from-file` or `--from-site` as an input."
          exit 127
        end
      end

      def exit_unless_valid_count(options)
        unless options.count > 0
          logger.error "Error: Specify a maximum book count greater than 0"
          exit 127
        end
      end
    end
  end
end
