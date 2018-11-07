module Klipbook
  module Sources
    class Source
      def self.build(options)
        if options.from_file
          file_source(options.from_file, options.count)
        else
          raise "Unknown source type"
        end
      end

      def self.file_source(file, max_books)
        Sources::KindleDevice::File.new(File.read(file), max_books)
      end
    end
  end
end
