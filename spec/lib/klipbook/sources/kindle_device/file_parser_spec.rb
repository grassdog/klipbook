# encoding: UTF-8

require 'spec_helper'

describe Klipbook::Sources::KindleDevice::FileParser do

  let(:parser) { Klipbook::Sources::KindleDevice::FileParser.new(highlight_parser) }

  let(:highlight_parser) do
    mock_parser = Object.new
    stub(mock_parser).build_highlight
    mock_parser
  end

  describe '#extract_highlights' do
    subject { parser.extract_highlights(raw_text) }

    context 'called with empty text' do

      let(:raw_text) { '' }

      it { should be_empty }
    end

    context 'called with text containing two highlight sections' do
      let(:raw_text) do
        " highlight one" +
        "==========" +
        " highlight two" +
        "=========="
      end

      it 'builds two highlights with the highlight parser and returns them' do
        highlight_one = Object.new
        highlight_two = Object.new

        stub(highlight_parser).build_highlight(' highlight one') { highlight_one }
        stub(highlight_parser).build_highlight(' highlight two') { highlight_two }

        subject.should == [ highlight_one, highlight_two ]
      end
    end

    context 'called with text containing carriage return characters' do
      let(:raw_text) do
        "Example \r text\r" +
        "=========="
      end

      it 'strips carriage returns before calling the highlight parser' do
        subject
        highlight_parser.should have_received.build_highlight('Example  text')
      end
    end

    context 'called with text containing control characters' do
      let(:raw_text) do
        "Example \xef\xbb\xbf text\xef\xbb\xbf" +
        "=========="
      end

      it 'strips control characters before calling the highlight parser' do
        subject
        highlight_parser.should have_received.build_highlight('Example  text')
      end
    end
  end
end
