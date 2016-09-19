module Klipbook::Sources
  module AmazonSite
    class BookScraper

      def scrape_book(page)
        page.search(".//div[@class='bookMain yourHighlightsHeader']").map { |element| build_book(page, element) }
      end

      private

      def build_book(page, element)
        Klipbook::Book.new.tap do |b|
          b.asin = element.attribute("id").value.gsub(/_[0-9]+$/, "")
          b.author = element.xpath("span[@class='author']").text.gsub("\n", "").gsub(" by ", "").strip
          b.title = element.xpath("span/a").text
          b.last_update = extract_last_update(element.xpath("div[@class='lastHighlighted']").text)
          b.clippings = scrape_clippings(page)
        end
      end

      def extract_last_update(text)
        text = text.gsub('Last annotated on ', '')
        DateTime.parse(text)
      end

      def scrape_clippings(page)
        page.search(".//div[@class='highlightRow yourHighlight']").map { |element| build_clipping(element) }.flatten
      end

      def build_clipping(element)
        location = extract_location(element)
        annotation_id = element.xpath("form/input[@id='annotation_id']").attribute("value").value
        note_text = element.xpath("p/span[@class='noteContent']").text

        highlight = Klipbook::Clipping.new.tap do |c|
          c.annotation_id = annotation_id
          c.text = element.xpath("span[@class='highlight']").text
          c.type = :highlight
          c.location = location
        end

        if note_text.blank?
          highlight
        else
          note = Klipbook::Clipping.new.tap do |c|
            c.annotation_id = annotation_id
            c.text = note_text
            c.type = :note
            c.location = location
          end

          [highlight, note]
        end
      end

      def extract_location(element)
        if element.xpath("a[@class='k4pcReadMore readMore linkOut']").attribute("href").value =~ /location=([0-9]+)$/
          $1.to_i
        else
          0
        end
      end
    end
  end
end
