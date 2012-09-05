require 'mechanize'

module Klipbook::Sources
  module AmazonSite
    class Scraper
      def initialize(username, password, max_books,
                     book_scraper=Klipbook::Sources::AmazonSite::BookScraper.new,
                     message_stream=$stdout)
        @max_books = max_books
        @message_stream = message_stream
        @agent = Mechanize.new
        @book_scraper = book_scraper
      end

      def books
        @books ||= fetch_books
      end

      private

      def fetch_books
        login_form = login

        signin_submission = @agent.submit(login_form)
        page = @agent.click(signin_submission.link_with(:text => /Your Highlights/))

        scrape_books(page)
      end

      def login
        @message_stream.puts 'Logging into site'

        page = @agent.get("https://www.amazon.com/ap/signin?openid.return_to=https%3A%2F%2Fkindle.amazon.com%3A443%2Fauthenticate%2Flogin_callback%3Fwctx%3D%252F&pageId=amzn_kindle&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.pape.max_auth_age=0&openid.assoc_handle=amzn_kindle&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select")
        login_form = page.form('signIn')

        login_form.email = username
        login_form.password = password

        login_form
      end

      def scrape_books(page)
        books = []
        @message_stream.print 'Fetching books '

        @max_books.times do |count|
          @message_stream.print '.'
          books << @book_scraper.scrape_book(page)
          page = get_next_page(page)
          break unless page
        end

        puts ' Done!'

        books.flatten
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
  end
end
