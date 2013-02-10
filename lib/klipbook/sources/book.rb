module Klipbook
  class Book
    attr_accessor :asin, :author, :title, :last_update, :clippings

    def initialize
      yield self if block_given?
    end

    def title_and_author
      author_txt = author ? " by #{author}" : ''
      "#{title}#{author_txt}"
    end

    def get_binding
      binding
    end

    def location_html(location)
      if self.asin
        "<a href=\"kindle://book?action=open&asin=#{asin}&location=#{location}\">loc #{location}</a>"
      else
        "loc #{location}"
      end
    end
  end
end
