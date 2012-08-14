# encoding: UTF-8

module Klipbook::Sources
  module KindleDevice
    class FileParser
      def initialize(highlight_parser)
        @highlight_parser = highlight_parser
      end

      def extract_highlights(file_text)
        highlights = split_file_into_raw_highlights(file_text)

        build_highlights(highlights)
      end

      def build_highlights(highlight_texts)
        highlight_texts.map do |highlight_text|
          @highlight_parser.build_highlight(highlight_text)
        end.compact
      end

    private

      def strip_control_characters(file_text)
        file_text.gsub("\r", '').gsub("\xef\xbb\xbf", '')
      end

      def split_file_into_raw_highlights(file_text)
        strip_control_characters(file_text).split('==========')
      end
    end
  end
end
