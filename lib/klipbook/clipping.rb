module Klipbook
  class Clipping
    attr_accessor :annotation_id, :text, :location, :type, :page

    # highlight link
    # kindle://book?action=open&asin=B001GSTOAM&location=1112

    def initialize
      yield self if block_given?
    end
  end
end
