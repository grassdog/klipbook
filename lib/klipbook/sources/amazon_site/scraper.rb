require 'mechanize'

module Klipbook::Sources
  module AmazonSite
    class Scraper
      def initialize(username, password,
                     book_scraper=Klipbook::Sources::AmazonSite::BookScraper,
                     message_stream=$stdout, max_books=100)
        @max_books = max_books
        @message_stream = message_stream
        @agent = Mechanize.new

        @book_scraper = book_scraper.new(@agent)

        page = @agent.get("https://www.amazon.com/ap/signin?openid.return_to=https%3A%2F%2Fkindle.amazon.com%3A443%2Fauthenticate%2Flogin_callback%3Fwctx%3D%252F&pageId=amzn_kindle&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.pape.max_auth_age=0&openid.assoc_handle=amzn_kindle&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select")
        @login_form = page.form('signIn')

        @login_form.email = username
        @login_form.password = password
      end

      def books
        scrape_site
      end

      private

      def scrape_site
        @message_stream.puts 'Logging into site'
        signin_submission = @agent.submit(@login_form)
        highlights_page   = @agent.click(signin_submission.link_with(:text => /Your Highlights/))

        @book_scraper.scrape_books(highlights_page)
      end
    end
  end
end
