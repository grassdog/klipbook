# coding: utf-8
module Klipbook
  Book = Struct.new(:asin, :author, :title, :last_update, :clippings) do
    def title_and_author
      author_txt = author ? " by #{author}" : ''
      "#{title}#{author_txt}"
    end

    def get_binding
      binding
    end

    def location_html(location)
      if asin
        "<a href=\"kindle://book?action=open&asin=#{asin}&location=#{location}\">loc #{location}</a>"
      else
        "loc #{location}"
      end
    end

    def location_markdown(location)
      if asin
        "[∞](kindle://book?action=open&asin=#{asin}&location=#{location})"
      else
        ""
      end
    end

    def self.from_hash(hash)
      self.new.tap do |b|
        b.asin = hash['asin']
        b.author = hash['author']
        b.title = hash['title']
        b.last_update = hash['last_update']
        b.clippings = hash['clippings'].map { |clip| Klipbook::Clipping.from_hash(clip) }
      end
    end
  end
end
