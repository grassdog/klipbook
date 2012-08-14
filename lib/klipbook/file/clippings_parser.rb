# encoding: UTF-8

module Klipbook
  class ClippingsParser
    def extract_clippings_from(file_text)
      clippings_text_from(file_text).map { |clipping_text| build_clipping_from(clipping_text) }.compact
    end

    def build_clipping_from(clipping_text)
      return nil if clipping_text.blank?

      attributes = extract_attributes(clipping_text)

      Clipping.new(attributes)
    end

    def extract_attributes(clipping_text)

      lines = clipping_text.lstrip.lines.to_a

      return nil if lines.length < 2

      title_line = lines[0].strip
      metadata = lines[1].strip
      text_lines = lines[3..-1]

      return nil unless valid_metadata?(metadata)

      {
        title:    extract_title(title_line),
        author:   extract_author(title_line),
        type:     extract_type(metadata),
        location: extract_location(metadata),
        page:     extract_page(metadata),
        added_on: extract_added_date(metadata),
        text:     extract_text(text_lines)
      }
    end

    def strip_control_characters(file_text)
      file_text.gsub("\r", '').gsub("\xef\xbb\xbf", '')
    end

  private

    def clippings_text_from(file_text)
      strip_control_characters(file_text).split('==========')
    end

    def valid_metadata?(metadata)
      metadata.match(/^-.*Added on/)
    end

    def extract_title(title_line)
      if title_line =~ /\(.+\)\Z/
        title_line.scan(/(.*)\s+\(.+\)\Z/).first.first
      else
        title_line
      end
    end

    def extract_author(title_line)
      match = title_line.scan /\(([^\(]+)\)\Z/
      match.empty? ? nil : match.first.first
    end

    def extract_type(metadata)
      type = metadata.scan(/^-( Your)? (\w+)/).first[1]
      type.downcase.to_sym
    end

    def extract_added_date(metadata)
      metadata.scan(/Added on (.+)$/i).first.first
    end

    def extract_location(metadata)
      match = metadata.scan(/Loc(ation|\.) ([0-9]+-?)/)

      return nil if match.empty?

      location = match.first[1]
      location.to_i
    end

    def extract_page(metadata)
      match = metadata.scan(/Page (\d+)/)

      return nil if match.empty?

      location = match.first.first
      location.to_i
    end

    def extract_text(text_lines)
      text_lines.join('').rstrip
    end
  end
end
