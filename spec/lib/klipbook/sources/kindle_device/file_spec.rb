require 'spec_helper'

describe Klipbook::Sources::KindleDevice::File do

  let(:file) { Klipbook::Sources::KindleDevice::File.new('file text', file_parser, book_list) }

  let (:entries) { [] }

  let (:file_parser) do
    Object.new.tap do |fake_parser|
      stub(fake_parser).extract_entries { entries }
    end
  end

  let (:book_list) do
    Object.new.tap do |fake_book_list|
      stub(fake_book_list).books_from_entries { [] }
    end
  end

  describe '#books' do
    subject { file.books }

    it 'parses the file text with the file parser' do
      subject
      file_parser.should have_received.extract_entries('file text')
    end

    context 'with entries for multiple books' do
      let(:first_book_one_entry) do
        Klipbook::Sources::KindleDevice::Entry.new do |e|
          e.title = 'Book one'
          e.author = 'Author one'
        end
      end

      let(:first_book_two_entry) do
        Klipbook::Sources::KindleDevice::Entry.new do |e|
          e.title = 'Book two'
          e.author = 'Author two'
        end
      end

      let(:second_book_one_entry) do
        Klipbook::Sources::KindleDevice::Entry.new do |e|
          e.title = 'Book one'
          e.author = 'Author one'
        end
      end

      let(:entries) do
        [
          second_book_one_entry,
          first_book_two_entry,
          first_book_one_entry
        ]
      end

      it 'groups entries by book and builds a book list' do
        subject
        book_list.should have_received.books_from_entries([
          second_book_one_entry,
          first_book_one_entry,
          first_book_two_entry])
      end

      it 'returns the books created by the book list sorted by title' do
        book1 = Klipbook::Book.new { |b| b.title = "First title" }
        book2 = Klipbook::Book.new { |b| b.title = "Second title" }
        books = [book2, book1]

        stub(book_list).books_from_entries { books }
        subject.should == [ book1, book2 ]
      end
    end
  end
end
