module Klipbook
  class Clipping
    attr_accessor :annotation_id, :text, :location, :type, :page

    def initialize
      yield self if block_given?
    end
  end
end
