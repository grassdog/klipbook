require 'spec_helper'

describe Klipbook::Sources::KindleDevice::File do

  let(:file) { Klipbook::Sources::KindleDevice::File.new('file text', file_parser) }

  let (:entries) { [] }

  let (:file_parser) do
    Object.new.tap do |fake_parser|
      stub(fake_parser).extract_entries { entries }
    end
  end

  describe '#books' do
    subject { file.books }

    it 'parses the file text with the file parser' do
      subject
      file_parser.should have_received.extract_entries('file text')
    end

    context 'with entries for two books' do
      let(:entries) do
        [
          Klipbook::Sources::KindleDevice::Entry.new do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :highlight
          end,
          Klipbook::Sources::KindleDevice::Entry.new do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :highlight
          end,
          Klipbook::Sources::KindleDevice::Entry.new do |e|
            e.title = 'Book two'
            e.author = 'Author two'
            e.type = :highlight
          end
        ]
      end

      it 'returns two books' do
        subject.should have(2).items
      end

      it 'returns books sorted by title' do
        subject.map(&:title).should == [ 'Book one', 'Book two' ]
      end
    end

    context 'with entries for a single book' do
      let(:entries) do
        [
          Klipbook::Sources::KindleDevice::Entry.new do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :bookmark
            e.location = 1
            e.page = 1
            e.added_on = DateTime.new(2012, 10, 10)
            e.text = 'First one'
          end,
          Klipbook::Sources::KindleDevice::Entry.new do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :highlight
            e.location = 10
            e.page = 3
            e.added_on = DateTime.new(2012, 10, 11)
            e.text = 'Second one'
          end,
          Klipbook::Sources::KindleDevice::Entry.new do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :highlight
            e.location = 3
            e.page = 2
            e.added_on = DateTime.new(2012, 10, 1)
            e.text = 'Third one'
          end,
          Klipbook::Sources::KindleDevice::Entry.new do |e|
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
        subject.first.title.should == 'Book one'
        subject.first.author.should == 'Author one'
      end

      it "returns a single book with last update equal to the latest added on date of the book's entries" do
        subject.first.last_update.should == DateTime.new(2012, 10, 21)
      end

      it "ignores bookmarks when building the book's clipping list" do
        subject.first.clippings.should have(3).items
        subject.first.clippings.map(&:type).should_not include(:bookmark)
      end

      it 'returns a single book whose clippings are sorted by location' do
        subject.first.clippings.map(&:location).should == [2, 3, 10]
        subject.first.clippings.map(&:text).should == ['Fourth one', 'Third one', 'Second one']
        subject.first.clippings.map(&:page).should == [1, 2, 3]
      end
    end

    context 'with entries for a single book that are all bookmarks' do
      let(:entries) do
        [
          Klipbook::Sources::KindleDevice::Entry.new do |e|
            e.title = 'Book one'
            e.author = 'Author one'
            e.type = :bookmark
            e.location = 1
            e.page = 1
            e.added_on = DateTime.new(2012, 10, 10)
            e.text = 'First one'
          end,
          Klipbook::Sources::KindleDevice::Entry.new do |e|
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

      it { should be_empty }
    end
  end
end
