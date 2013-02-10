class String

  # A string is blank if it's empty or contains whitespaces only:
  #
  #   "".blank?                 # => true
  #   "   ".blank?              # => true
  #   " something here ".blank? # => false
  #
  def blank?
    self !~ /\S/
  end
end

class NilClass

  # +nil+ is blank:
  #
  #   nil.blank? # => true
  #
  def blank?
    true
  end
end

