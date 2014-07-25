require 'spec_helper'

describe Klipbook::ToJson::BookFile do

  describe '.from_json' do

    subject { Klipbook::ToJson::BookFile.from_json(json) }

    context 'with empty json' do

      let(:json) { '' }

      it 'returns an object with no books' do
        expect(subject.books).to be_empty
      end
    end
  end

  describe '#add_books' do
    let (:message_stream) do
      double(puts: nil)
    end

    let(:it) do
      books = [
        Klipbook::Book.new.tap do |b|
          b.title = "Book one"
          b.author = "Author one"
        end,
        Klipbook::Book.new.tap do |b|
          b.title = "Book two"
          b.author = "Author two"
        end
      ]
      Klipbook::ToJson::BookFile.new(books)
    end

    it "adds any books that don't already exist" do
      new_book = Klipbook::Book.new.tap do |b|
        b.title = 'Book three'
        b.author = 'Author two'
      end

      it.add_books([ new_book ], false, message_stream)

      expect(it.books.size).to eq 3
      expect(it.books).to include(new_book)
    end

    it "replaces books that exist if force is true" do
      new_book = Klipbook::Book.new.tap do |b|
        b.title = 'Book one'
        b.author = 'Author one'
        b.asin = 'new asin'
      end

      it.add_books([ new_book ], true, message_stream)

      expect(it.books.size).to eq 2
      expect(it.books).to include(new_book)
    end

    it "does not replace existing books if force is false" do
      new_book = Klipbook::Book.new.tap do |b|
        b.title = 'Book one'
        b.author = 'Author one'
        b.asin = 'new asin'
      end

      it.add_books([ new_book ], false, message_stream)

      expect(it.books.size).to eq 2
      expect(it.books).not_to include(new_book)
    end
  end
end
