require 'spec_helper'

describe Klipbook::Collate::BookFile do

  describe '.from_json' do

    subject { Klipbook::Collate::BookFile.from_json(json) }

    context 'with empty json' do

      let(:json) { '' }

      its(:books) { should be_empty }
    end
  end

  describe '#add_books' do
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
      Klipbook::Collate::BookFile.new(books)
    end

    it "adds any books that don't already exist" do
      new_book = Klipbook::Book.new.tap do |b|
        b.title = 'Book three'
        b.author = 'Author two'
      end

      it.add_books([ new_book ], false)
      it.books.should have(3).items
      it.books.should include(new_book)
    end

    it "replaces books that exist if force is true" do
      new_book = Klipbook::Book.new.tap do |b|
        b.title = 'Book one'
        b.author = 'Author one'
        b.asin = 'new asin'
      end

      it.add_books([ new_book ], true)
      it.books.should have(2).items
      it.books.should include(new_book)
    end

    it "does not replace existing books if force is false" do
      new_book = Klipbook::Book.new.tap do |b|
        b.title = 'Book one'
        b.author = 'Author one'
        b.asin = 'new asin'
      end

      it.add_books([ new_book ], false)
      it.books.should have(2).items
      it.books.should_not include(new_book)
    end
  end
end
