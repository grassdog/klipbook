require 'ostruct'
require 'erb'

module Klipbook
  class BookSummary
    attr_accessor :title, :author, :clippings

    def initialize(title, author, clippings=[])
      @title = title
      @author = author
      @clippings = clippings.sort
    end

    def hash
      title.hash ^ author.hash
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      return false unless other.instance_of?(self.class)
      title == other.title && author == other.author
    end

    def as_html(options={})
      include_pages = options[:include_pages]
      ERB.new(template, 0, '%<>').result(binding)
    end

    def template
      @template ||= File.read(File.join(File.dirname(__FILE__), 'book_summary.erb'))
    end
  end
end
