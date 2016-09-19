# encoding: UTF-8

module Klipbook
  module Sources
    module KindleDevice
      class FileParser
        def initialize(entry_parser=EntryParser.new)
          @entry_parser = entry_parser
        end

        def extract_entries(file_text)
          entries_text = split_into_raw_entries_text(file_text)

          build_entries(entries_text)
        end

        private

        def build_entries(entries_text)
          entries_text.map do |entry_text|
            @entry_parser.build_entry(entry_text)
          end.compact
        end

        def strip_control_characters(file_text)
          file_text.gsub("\r", '').gsub("\xef\xbb\xbf", '')
        end

        def split_into_raw_entries_text(file_text)
          strip_control_characters(file_text).split('==========')
        end
      end
    end
  end
end
