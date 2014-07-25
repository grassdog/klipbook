# encoding: UTF-8

require 'spec_helper'

RSpec.describe Klipbook::Sources::KindleDevice::FileParser do

  let(:parser) { Klipbook::Sources::KindleDevice::FileParser.new(entry_parser) }

  let(:entry_parser) do
    double('parser', build_entry: nil)
  end

  describe '#extract_entries' do
    subject { parser.extract_entries(raw_text) }

    context 'called with empty text' do

      let(:raw_text) { '' }

      it 'return an empty set of entries' do
        expect(subject).to be_empty
      end
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

        allow(entry_parser).to receive(:build_entry).with(' entry one') { entry_one }
        allow(entry_parser).to receive(:build_entry).with(' entry two') { entry_two }

        expect(subject).to eq [ entry_one, entry_two ]
      end
    end

    context 'called with text containing carriage return characters' do
      let(:raw_text) do
        "Example \r text\r" +
        "=========="
      end

      it 'strips carriage returns before calling the entry parser' do
        subject
        expect(entry_parser).to have_received(:build_entry).with('Example  text')
      end
    end

    context 'called with text containing control characters' do
      let(:raw_text) do
        "Example \xef\xbb\xbf text\xef\xbb\xbf" +
        "=========="
      end

      it 'strips control characters before calling the entry parser' do
        subject
        expect(entry_parser).to have_received(:build_entry).with('Example  text')
      end
    end
  end
end
