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

      protected

      attr_reader :logger

      private

      def book_source(options)
        exit_unless_valid_source(options)

        unless options.count > 0
          logger.error "Error: Specify a maximum book count greater than 0"
          exit 127
        end

        if options.from_file
          file_source(options.from_file, options.count)
        elsif options.from_site
          site_source(options.from_site, options.count)
        else
          raise "Unknown source type"
        end
      end

      def exit_unless_valid_source(options)
        unless options.from_file || options.from_site
          logger.error "Error: You must specify either `--from-file` or `--from-site` as an input."
          exit 127
        end
      end

      def site_source(credentials, max_books)
        unless credentials =~ /(.+):(.+)/
          logger.error "Error: your credentials need to be in username:password format."
          exit 127
        end

        username = $1
        password = $2
        Sources::AmazonSite::SiteScraper.new(username, password, max_books)
      end

      def file_source(file, max_books)
        Sources::KindleDevice::File.new(File.read(file), max_books)
      end
    end
  end
end
