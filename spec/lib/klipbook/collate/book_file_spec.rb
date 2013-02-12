require 'spec_helper'

describe Klipbook::Collate::BookFile do

  describe '#add_books' do
    let(:it) do
      Klipbook::Collate::BookFile.new([])
    end

    it 'adds all books' do
      new_book = Klipbook::Book.new.tap do |b|
        b.title = 'Book three'
        b.author = 'Author two'
      end

      it.add_books([ new_book ])
      it.books.should == [ new_book ]
    end
  end
end
