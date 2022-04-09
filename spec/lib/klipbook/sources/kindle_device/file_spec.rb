require 'spec_helper'

RSpec.describe Klipbook::Sources::KindleDevice::File do
  let(:file) { Klipbook::Sources::KindleDevice::File.new(input_text, max_books, file_parser) }

  let(:max_books) { 30 }

  let(:entries) { [] }

  let(:file_parser) { double(extract_entries: entries) }

  let(:input_text) { 'file text' }

  describe '#books' do
    subject { file.books }

    it 'parses the file text with the file parser' do
      subject
      expect(file_parser).to have_received(:extract_entries).with('file text')
    end

    context 'with entries for three books' do
      let(:entries) do
        [
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :highlight
            e.added_on = DateTime.new(2012, 10, 10)
          end,
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :highlight
            e.added_on = DateTime.new(2012, 10, 10)
          end,
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book two'
            e.author = 'Author two'
            e.type = :highlight
            e.added_on = DateTime.new(2012, 10, 12)
          end,
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book three'
            e.author = 'Author two'
            e.type = :highlight
            e.added_on = DateTime.new(2012, 10, 11)
          end
        ]
      end

      it 'returns three books' do
        expect(subject.size).to eq 3
      end

      it 'returns books sorted by last_update descending' do
        expect(subject.map(&:title)).to eq [ 'Book two', 'Book three', 'Book one' ]
      end

      context 'and max_books set to 2' do

        let (:max_books) { 2 }

        it 'returns two books' do
          expect(subject.size).to eq 2
        end
      end
    end

    context 'with entries for a single book' do
      let(:entries) do
        [
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :bookmark
            e.location = 1
            e.page = 1
            e.added_on = DateTime.new(2012, 10, 10)
            e.text = 'First one'
          end,
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :highlight
            e.location = 10
            e.page = 3
            e.added_on = DateTime.new(2012, 10, 11)
            e.text = 'Second one'
          end,
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :highlight
            e.location = 3
            e.page = 2
            e.added_on = DateTime.new(2012, 10, 1)
            e.text = 'Third one'
          end,
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :note
            e.location = 2
            e.page = 1
            e.added_on = DateTime.new(2012, 10, 21)
            e.text = 'Fourth one'
          end
        ]
      end

      it 'returns a single book with the correct title and author information' do
        expect(subject.first.title).to eq 'Book one'
        expect(subject.first.author).to eq 'Author one'
      end

      it "returns a single book with last update equal to the latest added on date of the book's entries" do
        expect(subject.first.last_update).to eq DateTime.new(2012, 10, 21)
      end

      it "ignores bookmarks when building the book's clipping list" do
        expect(subject.first.clippings.size).to eq 3
        expect(subject.first.clippings.map(&:type)).not_to include(:bookmark)
      end

      it 'returns a single book whose clippings are sorted by location' do
        expect(subject.first.clippings.map(&:location)).to eq [2, 3, 10]
        expect(subject.first.clippings.map(&:text)).to eq ['Fourth one', 'Third one', 'Second one']
        expect(subject.first.clippings.map(&:page)).to eq [1, 2, 3]
      end
    end

    context 'with entries for a single book that are all bookmarks' do
      let(:entries) do
        [
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :bookmark
            e.location = 1
            e.page = 1
            e.added_on = DateTime.new(2012, 10, 10)
            e.text = 'First one'
          end,
          Klipbook::Sources::KindleDevice::Entry.new.tap do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :bookmark
            e.location = 10
            e.page = 3
            e.added_on = DateTime.new(2012, 10, 11)
            e.text = 'Second one'
          end
        ]
      end

      it 'should be empty' do
        expect(subject).to be_empty
      end
    end
  end
end
