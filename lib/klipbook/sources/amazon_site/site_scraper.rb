# This scraping code is taken from https://github.com/parroty/kindle-highlights
# which isn't currently available as a gem.

require 'mechanize'
require 'nokogiri'
require 'erb'
require 'date'

class KindleHighlight
  attr_accessor :highlights, :books

  DEFAULT_PAGE_LIMIT = 1
  DEFAULT_DAY_LIMIT  = 365 * 100  # set default as 100 years
  DEFAULT_WAIT_TIME  = 5

  def initialize(email_address, password, options = {}, &block)
    @agent = Mechanize.new
    page = @agent.get("https://www.amazon.com/ap/signin?openid.return_to=https%3A%2F%2Fkindle.amazon.com%3A443%2Fauthenticate%2Flogin_callback%3Fwctx%3D%252F&pageId=amzn_kindle&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.pape.max_auth_age=0&openid.assoc_handle=amzn_kindle&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select")
    @amazon_form = page.form('signIn')

    @amazon_form.email    = email_address
    @amazon_form.password = password

    @page_limit = options[:page_limit] || DEFAULT_PAGE_LIMIT
    @day_limit  = options[:day_limit]  || DEFAULT_DAY_LIMIT
    @wait_time  = options[:wait_time]  || DEFAULT_WAIT_TIME

    @block = block

    scrape_highlights
  end

  def scrape_highlights
    signin_submission = @agent.submit(@amazon_form)
    highlights_page   = @agent.click(signin_submission.link_with(:text => /Your Highlights/))

    @books = []
    @highlights = []
    @page_limit.times do | cnt |
      @books      += collect_book(highlights_page)
      @highlights += collect_highlight(highlights_page)

      date_diff_from_today = (Date.today - Date.parse(@books.last.last_update)).to_i
      break if date_diff_from_today > @day_limit

      highlights_page = get_next_page(highlights_page)
      break unless highlights_page
      sleep(@wait_time) if cnt != 0

      @block.call(self) if @block
    end
  end

  def merge!(list)
    list.books.each do | b |
      @books.delete_if { |x| x.asin == b.asin }
      @books << b
    end

    list.highlights.each do | h |
      @highlights.delete_if { |x| x.annotation_id == h.annotation_id }
      @highlights << h
    end
  end

  def list
    List.new(@books, @highlights)
  end

private
  def collect_book(page)
    page.search(".//div[@class='bookMain yourHighlightsHeader']").map { |b| Book.new(b) }
  end

  def collect_highlight(page)
    page.search(".//div[@class='highlightRow yourHighlight']").map { |h| Highlight.new(h) }
  end

  def get_next_page(page)
    ret = page.search(".//a[@id='nextBookLink']").first
    if ret and ret.attribute("href")
      @agent.get("https://kindle.amazon.com" + ret.attribute("href").value)
    else
      nil
    end
  end
end

class KindleHighlight::List
  attr_accessor :books, :highlights, :highlights_hash

  def initialize(books, highlights)
    @books = books
    @highlights = highlights
    @highlights_hash = get_highlights_hash
  end

  def dump(file_name)
    File.open(file_name, "w") do | f |
      Marshal.dump(self, f)
    end
  end

  def self.load(file_name)
    Marshal.load(File.open(file_name))
  end

private
  def get_highlights_hash
    hash = Hash.new([].freeze)
    @highlights.each do | h |
      hash[h.asin] += [h]
    end
    hash
  end
end

class KindleHighlight::Book
  attr_accessor :asin, :author, :title, :last_update

  @@amazon_items = Hash.new

  def initialize(item)
    @asin        = item.attribute("id").value.gsub(/_[0-9]+$/, "")
    @author      = item.xpath("span[@class='author']").text.gsub("\n", "").gsub(" by ", "").strip
    @title       = item.xpath("span/a").text
    @last_update = item.xpath("div[@class='lastHighlighted']").text

    @@amazon_items[@asin] = {:author => author, :title => title}
  end

  def self.find(asin)
    @@amazon_items[asin] || {:author => "", :title => ""}
  end
end

class KindleHighlight::Highlight
  attr_accessor :annotation_id, :asin, :author, :title, :content, :location, :note

  @@amazon_items = Hash.new

  def initialize(highlight)
    @annotation_id = highlight.xpath("form/input[@id='annotation_id']").attribute("value").value
    @asin          = highlight.xpath("p/span[@class='hidden asin']").text
    @content       = highlight.xpath("span[@class='highlight']").text
    @note          = highlight.xpath("p/span[@class='noteContent']").text

    if highlight.xpath("a[@class='k4pcReadMore readMore linkOut']").attribute("href").value =~ /location=([0-9]+)$/
      @location = $1.to_i
    end

    book = KindleHighlight::Book.find(@asin)
    @author = book[:author]
    @title  = book[:title]
  end
end
