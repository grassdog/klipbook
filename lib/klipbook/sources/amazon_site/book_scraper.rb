require 'mechanize'

module Klipbook::Sources
  module AmazonSite
    class BookScraper
      def initialize(agent, message_stream=$stdout)
        @agent = agent
        @message_stream = message_stream
      end

      def scrape_books(page)
        books = []

        begin
          books << scrape_book(page)
        end while page = get_next_page(page)

        books
      end

      private

      def scrape_book(page)
        @message_stream.puts 'Fetching book'
        page.search(".//div[@class='bookMain yourHighlightsHeader']").map { |element| build_book(element) }
      end

      def scrape_highlights(page)
        page.search(".//div[@class='highlightRow yourHighlight']").map { |element| build_clipping(element) }
      end

      def get_next_page(page)
        ret = page.search(".//a[@id='nextBookLink']").first
        if ret and ret.attribute("href")
          @agent.get("https://kindle.amazon.com" + ret.attribute("href").value)
        else
          nil
        end
      end

      def build_book(element)
        Klipbook::Book.new do |b|
          b.asin = element.attribute("id").value.gsub(/_[0-9]+$/, "")
          b.author = element.xpath("span[@class='author']").text.gsub("\n", "").gsub(" by ", "").strip
          b.title = element.xpath("span/a").text
          b.last_update = extract_last_update(element.xpath("div[@class='lastHighlighted']").text)
        end
      end

      def build_clipping(element)
        Klipbook::Clipping.new do |c|
          c.annotation_id = element.xpath("form/input[@id='annotation_id']").attribute("value").value
          c.asin = element.xpath("p/span[@class='hidden asin']").text
          c.text = element.xpath("span[@class='highlight']").text
          c.type = :highlight

          # TODO Extract notes
          #c.note = element.xpath("p/span[@class='noteContent']").text

          if element.xpath("a[@class='k4pcReadMore readMore linkOut']").attribute("href").value =~ /location=([0-9]+)$/
            c.location = $1.to_i
          end
        end
      end

      def extract_last_update(text)
        text = text.gsub('Last annotated on ', '')
        DateTime.parse(text)
      end
    end
  end
end
