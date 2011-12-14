require 'ostruct'
require 'date'

module Klipbook
  class Clipping < OpenStruct
    def initialize(attributes)
      super(attributes)
      self.added_on = DateTime.strptime(self.added_on, '%A, %B %d, %Y, %I:%M %p') if self.added_on
    end

    def <=>(other)
      (self.location || 0) <=> (other.location || 0)
    end
  end
end
