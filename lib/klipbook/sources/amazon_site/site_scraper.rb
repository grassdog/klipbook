require 'mechanize'

module Klipbook::Sources
  module AmazonSite
    class SiteScraper
      def initialize(username, password, max_books,
                     book_scraper=Klipbook::Sources::AmazonSite::BookScraper.new,
                     message_stream=$stdout)
        @username = username
        @password = password
        @max_books = max_books
        @message_stream = message_stream
        @agent = Mechanize.new do |a|
          a.user_agent_alias = 'Mac Safari'
        end
        @book_scraper = book_scraper
      end

      def books
        @books ||= fetch_up_to_max_books
      end

      private

      def fetch_up_to_max_books
        scrape_books(fetch_first_books_page)
      end

      def fetch_first_books_page
        welcome_page = get_welcome_page

        raise 'Invalid Username or password' unless welcome_page.title == 'Amazon Kindle: Home'

        @agent.click(welcome_page.link_with(:text => /Your Highlights/))
      end

      def get_welcome_page
        @message_stream.puts 'Logging into site'

        begin
          page = @agent.get("https://www.amazon.com/ap/signin?openid.return_to=https%3A%2F%2Fkindle.amazon.com%3A443%2Fauthenticate%2Flogin_callback%3Fwctx%3D%252F&pageId=amzn_kindle&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.pape.max_auth_age=0&openid.assoc_handle=amzn_kindle&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select")
        rescue
          raise 'Could not connect to Amazon Kindle Site'
        end

        login_form = page.form('signIn').tap do |f|
          f.email = @username
          f.password = @password
        end

        @agent.submit(login_form)
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
        next_book_link = page.link_with(:dom_id => "nextBookLink")
        if next_book_link
          @agent.click(next_book_link)
        else
          nil
        end
      end
    end
  end
end
