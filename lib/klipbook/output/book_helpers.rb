module Klipbook::Output
  module BookHelpers
    def location_html(location)
      if self.asin
        "<a href=\"kindle://book?action=open&asin=#{asin}&location=#{location}\">loc #{location}</a>"
      else
        "loc #{location}"
      end
    end
  end
end

