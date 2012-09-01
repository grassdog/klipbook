module Klipbook
  class Book
    attr_accessor :asin, :author, :title, :last_update, :clippings

    def initialize
      yield self if block_given?
    end

    def get_binding
      binding
    end
  end
end
