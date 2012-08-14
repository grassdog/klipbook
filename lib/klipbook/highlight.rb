require 'date'

module Klipbook
  class Highlight
    attr_accessor :annotation_id, :asin, :author, :title,
                  :content, :location, :note, :page

    #attr_accessor :annotation_id, :asin, :author, :title, :content, :location, :note

    # highlight link
    # kindle://book?action=open&asin=B001GSTOAM&location=1112

    def initialize
      yield self if block_given?
    end
  end
end
