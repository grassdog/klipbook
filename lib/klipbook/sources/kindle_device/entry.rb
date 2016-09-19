module Klipbook
  module Sources
    module KindleDevice
      class Entry
        attr_accessor :title, :author, :type, :location, :page, :added_on, :text

        def initialize
          yield self if block_given?
        end
      end
    end
  end
end
