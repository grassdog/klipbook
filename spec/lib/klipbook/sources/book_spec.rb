require 'spec_helper'

describe Klipbook::Book do
  describe '#title_and_author' do

    subject { book.title_and_author }

    context 'with no author' do
      let(:book) do
        Klipbook::Book.new do |b|
          b.title = 'Book title'
        end
      end

      it 'only contains the title' do
        subject.should == 'Book title'
      end
    end

    context 'with an author' do
      let(:book) do
        Klipbook::Book.new do |b|
          b.title = 'Book title'
          b.author = 'Rob Ripjaw'
        end
      end

      it 'contains the title and author' do
        subject.should == 'Book title by Rob Ripjaw'
      end
    end
  end
end
