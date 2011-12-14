require 'spec_helper'
require 'ostruct'

describe Klipbook::ClippingsFile do

  let(:clippings_file) { Klipbook::ClippingsFile.new('', parser) }

  let (:parser) do
    fake_parser = Object.new
    stub(fake_parser).extract_clippings_from { clippings }
    fake_parser
  end

  describe '#books' do
    subject { clippings_file.books }

    context 'with an empty clippings file' do
      let(:clippings) { [] }

      it { should be_empty }
    end

    context 'with a single clipping for a single book' do
      let(:clippings) do
        [ OpenStruct.new(title: 'First fake book title') ]
      end

      it 'contains an entry for the book' do
        subject.map(&:title).should == [ 'First fake book title' ]
      end
    end

    context 'with clippings for two books' do
      let(:clippings) do
        [
          OpenStruct.new(title: 'Second fake book title'),
          OpenStruct.new(title: 'First fake book title')
        ]
      end

      it 'contains entries for the two books in alphabetical order' do
        subject.map(&:title).should == [ 'First fake book title', 'Second fake book title' ]
      end
    end

    context 'with multiple clippings for two books' do
      let(:clippings) do
        [
          OpenStruct.new(title: 'First fake book title'),
          OpenStruct.new(title: 'Second fake book title'),
          OpenStruct.new(title: 'First fake book title')
        ]
      end

      it 'contains entries for the two books in alphabetical order' do
        subject.map(&:title).should == [ 'First fake book title', 'Second fake book title' ]
      end
    end
  end
end
