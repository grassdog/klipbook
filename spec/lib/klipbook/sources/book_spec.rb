require 'spec_helper'

RSpec.describe Klipbook::Book do
  describe '#title_and_author' do

    subject { book.title_and_author }

    context 'with no author' do
      let(:book) do
        Klipbook::Book.new.tap do |b|
          b.title = 'Book title'
        end
      end

      it 'only contains the title' do
        expect(subject).to eq 'Book title'
      end
    end

    context 'with an author' do
      let(:book) do
        Klipbook::Book.new.tap do |b|
          b.title = 'Book title'
          b.author = 'Rob Ripjaw'
        end
      end

      it 'contains the title and author' do
        expect(subject).to eq 'Book title by Rob Ripjaw'
      end
    end
  end
end
