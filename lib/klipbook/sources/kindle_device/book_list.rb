module Klipbook::Sources
  module KindleDevice
    class BookList
      def books_from_entries(entries)
        entries.select { |entry| entry.type != :bookmark }
               .group_by(&:title)
               .map { |title, entries| book_from_entries(entries) }
      end

      def book_from_entries(entries)
        entries.sort! { |ea, eb| ea.location <=> eb.location }

        Klipbook::Book.new do |b|
          b.title = entries.first.title
          b.author = entries.first.author
          b.last_update = entries.map(&:added_on).max
          b.clippings = entries.map do |e|
            Klipbook::Clipping.new do |c|
              c.location = e.location
              c.page = e.page
              c.text = e.text
              c.type = e.type
            end
          end
        end
      end
    end
  end
end

