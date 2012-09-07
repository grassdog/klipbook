require 'spec_helper'

describe Klipbook::Fetcher do

  let(:fake_source) do
    Object.new.tap do |fakey|
      stub(fakey).books { books }
    end
  end

  context 'when created with an invalid source' do
    it 'raises an error' do
      expect { Klipbook::Fetcher.new('sdf' , 2) }.to raise_error(InvalidSourceError)
    end
  end

  context 'when created with a site source' do
    subject { fetcher }

    let(:fetcher) { Klipbook::Fetcher.new('site:username@example.com:password', 2) }

    before(:each) do
      stub(Klipbook::Sources::AmazonSite::Scraper).new { fake_source }
    end

    it 'creates a site scraper with the provided credentials' do
      subject
      Klipbook::Sources::AmazonSite::Scraper.should have_received.new('username@example.com', 'password', 2)
    end

    describe '#fetch_books' do
      subject { fetcher.fetch_books }

      let(:books) { [] }

      it 'returns the books returned by the site source' do
        subject.should == books
      end
    end
  end

  context 'when created with a file source' do
    subject { fetcher }

    let(:fetcher) { Klipbook::Fetcher.new('file:filename', 2) }

    let(:fake_file) do
      Object.new.tap do |file|
        stub(file).read { file_contents }
      end
    end

    let(:file_contents) { 'fake contents ' }

    before(:each) do
      stub(Klipbook::Sources::KindleDevice::File).new { fake_source }
      stub(File).open { fake_file }
    end

    it "reads the file's contents from disk" do
      subject
      File.should have_received.open('filename', 'r')
    end

    it 'uses the file contents to create a file source' do
      subject

      Klipbook::Sources::KindleDevice::File.should have_received.new('fake contents', 2)
    end

    describe '#fetch_books' do
      subject { fetcher.fetch_books }

      let(:books) { [] }

      it 'returns the books returned by the file source' do
        subject.should == books
      end
    end
  end
end
