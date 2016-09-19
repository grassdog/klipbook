module Klipbook
  module Sources
    class Source
      def self.build(options)
        if options.from_file
          file_source(options.from_file, options.count)
        elsif options.from_site
          site_source(options.from_site, options.count)
        else
          raise "Unknown source type"
        end
      end

      def self.site_source(credentials, max_books)
        unless credentials =~ /(.+):(.+)/
          logger.error "Error: your credentials need to be in username:password format."
          exit 127
        end

        username = $1
        password = $2
        Sources::AmazonSite::SiteScraper.new(username, password, max_books)
      end

      def self.file_source(file, max_books)
        Sources::KindleDevice::File.new(File.read(file), max_books)
      end
    end
  end
end
