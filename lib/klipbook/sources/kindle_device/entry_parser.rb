module Klipbook
  module Sources
    module KindleDevice
      class EntryParser

        def build_entry(entry_text)
          return nil if invalid_entry?(entry_text)

          lines = split_text_into_lines(entry_text)
          title_line = lines[0].strip
          metadata = lines[1].strip
          text_lines = lines[3..-1]

          type = extract_type(metadata)

          Klipbook::Sources::KindleDevice::Entry.new do |h|
            h.title = extract_title(title_line)
            h.author = extract_author(title_line)
            h.location = extract_location(metadata)
            h.page = extract_page(metadata)
            h.added_on = extract_added_date(metadata)
            h.text = extract_content(text_lines)
            h.type = extract_type(metadata)
          end
        end

        private

        def invalid_entry?(entry_text)
          entry_text.blank? || incomplete_entry?(entry_text)
        end

        def incomplete_entry?(entry_text)
          split_text_into_lines(entry_text).length < 2
        end

        def split_text_into_lines(entry_text)
          entry_text.lstrip.lines.to_a
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

        def extract_location(metadata)
          match = metadata.scan(/Loc(ation|\.) ([0-9]+-?)/)

          return 0 if match.empty?

          location = match.first[1]
          location.to_i
        end

        def extract_page(metadata)
          match = metadata.scan(/Page (\d+)/)

          return nil if match.empty?

          location = match.first.first
          location.to_i
        end

        def extract_content(text_lines)
          text_lines.join('').rstrip
        end

        def extract_added_date(metadata)
          DateTime.parse(metadata.scan(/Added on (.+)$/i).first.first)
        end
      end
    end
  end
end
