require 'thor'

module Klipbook
  class CLI < Thor

    desc 'list CLIPPINGS_FILE', 'List the books in the clippings file'
    def list(clippings_file=nil)
      if (clippings_file.nil?)
        puts 'Please provide a CLIPPINGS_FILE'
        exit 1
      end

      clippings_file = ensure_clippings_file_exists(clippings_file)

      Klipbook::Runner.new(clippings_file).list_books
    end

    desc 'summarise CLIPPINGS_FILE  BOOK_NUMBER  OUTPUT_FILE', 'Output an html summary of the clippings for a book'
    method_option :include_pages, :aliases => '-p', :desc => 'Include page numbers in output when available'
    def summarise(clippings_file=nil, book_number=nil, output_file=nil)
      if (clippings_file.nil? or book_number.nil? or output_file.nil?)
        puts 'Please provide a CLIPPINGS_FILE, BOOK_NUMBER, and OUTPUT_FILE'
        exit 1
      end

      clippings_file = ensure_clippings_file_exists(clippings_file)

      book_number = book_number.to_i

      Klipbook::Runner.new(clippings_file).print_book_summary(book_number, File.open(output_file, 'w'), options)
    end

    map '-v' => :version
    desc 'version', 'Display Klipbook version'
    def version
      puts "Klipbook #{Klipbook::VERSION}"
    end

    no_tasks do
      def ensure_clippings_file_exists(clippings_file)
        unless File.exist?(clippings_file)
          $stderr.puts "Clippings file doesn't exist: #{clippings_file}"
          exit 1
        end
        File.open(clippings_file, 'r')
      end
    end
  end
end
