module Klipbook
  Book = Struct.new(:asin, :author, :title, :last_update, :clippings) do
    def title_and_author
      author_txt = author ? " by #{author}" : ''
      "#{title}#{author_txt}"
    end

    def sorted_clippings
      clippings.sort_by(&:location)
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
  end
end
