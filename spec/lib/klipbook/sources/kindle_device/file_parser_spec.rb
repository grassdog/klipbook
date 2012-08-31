# encoding: UTF-8

require 'spec_helper'

describe Klipbook::Sources::KindleDevice::FileParser do

  let(:parser) { Klipbook::Sources::KindleDevice::FileParser.new(entry_parser) }

  let(:entry_parser) do
    mock_parser = Object.new
    stub(mock_parser).build_entry
    mock_parser
  end

  describe '#extract_entries' do
    subject { parser.extract_entries(raw_text) }

    context 'called with empty text' do

      let(:raw_text) { '' }

      it { should be_empty }
    end

    context 'called with text containing two entries' do
      let(:raw_text) do
        " entry one" +
        "==========" +
        " entry two" +
        "=========="
      end

      it 'builds two entries with the entries parser and returns them' do
        entry_one = Object.new
        entry_two = Object.new

        stub(entry_parser).build_entry(' entry one') { entry_one }
        stub(entry_parser).build_entry(' entry two') { entry_two }

        subject.should == [ entry_one, entry_two ]
      end
    end

    context 'called with text containing carriage return characters' do
      let(:raw_text) do
        "Example \r text\r" +
        "=========="
      end

      it 'strips carriage returns before calling the entry parser' do
        subject
        entry_parser.should have_received.build_entry('Example  text')
      end
    end

    context 'called with text containing control characters' do
      let(:raw_text) do
        "Example \xef\xbb\xbf text\xef\xbb\xbf" +
        "=========="
      end

      it 'strips control characters before calling the entry parser' do
        subject
        entry_parser.should have_received.build_entry('Example  text')
      end
    end
  end
end
