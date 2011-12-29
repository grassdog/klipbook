# encoding: UTF-8

require 'spec_helper'

describe Klipbook::ClippingsParser do

  describe '#extract_attributes' do

    subject { Klipbook::ClippingsParser.new.extract_attributes(content) }

    context 'on a clipping with the title line "Book title (Author\'s Name)"' do
      let (:content) do
        "Book title (Author's Name)\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight text\n"
      end

      it 'extracts the title as "Book title"' do
        subject[:title].should == 'Book title'
      end

      it 'extracts the author as "Author\'s Name"' do
        subject[:author].should == "Author's Name"
      end
    end

    context 'on a clipping with the title line "Book title (sub title) (Author\'s Name)"' do
      let (:content) do
        "Book title (sub title) (Author's Name)\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight text\n"
      end

      it 'extracts the title as "Book title (sub title)"' do
        subject[:title].should == 'Book title (sub title)'
      end

      it 'extracts the author "Author\'s Name"' do
        subject[:author].should == "Author's Name"
      end
    end

    context 'on a clipping with a byte-order mark in the title line' do
      # 2nd-generation Kindles have been observed to add a BOM at the beginning of the file
      # Kindle Touches have been observed (presumably due to a bug) to add BOM's like this inside a file, not just at the start of the file
      let (:content) do
        "\xef\xbb\xbfBook title (Author's Name)\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight test\n"
      end

      it 'extracts the title as "Book title"' do
        subject[:title].should == 'Book title'
      end

      it 'extracts the author "Author\'s Name"' do
        subject[:author].should == "Author's Name"
      end
    end

    context 'on a clipping with the title line "Book title"' do
      let (:content) do
        "Book title\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight text\n"
      end

      it 'extracts the title as "Book title"' do
        subject[:title].should == 'Book title'
      end

      it 'extracts no author' do
        subject[:author].should be_nil
      end
    end

    context 'on a highlight' do
      let (:content) do
        "Book title\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'marks the clipping as a highlight' do
        subject[:type].should == :highlight
      end

      it 'extracts the highlighted text' do
        subject[:text].should == "The first line of the highlight\nThe second line of the highlight"
      end
    end

    context 'on a 4th-generation highlight' do
      let (:content) do
        "Book title\n" +
        "- Your Highlight Location 466-69 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'marks the clipping as a highlight' do
        subject[:type].should == :highlight
      end

      it 'extracts the highlighted text' do
        subject[:text].should == "The first line of the highlight\nThe second line of the highlight"
      end
    end

    context 'on a note' do
      let (:content) do
        "Book title\n" +
        "- Note Loc. 623  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The note text"
      end

      it 'marks the clipping as a note' do
        subject[:type].should == :note
      end

      it 'extracts the note text' do
        subject[:text].should == "The note text"
      end
    end

    context 'on a 4th-generation note' do
      let (:content) do
        "Book title\n" +
        "- Your Note Location 623  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The note text"
      end

      it 'marks the clipping as a note' do
        subject[:type].should == :note
      end

      it 'extracts the note text' do
        subject[:text].should == "The note text"
      end
    end

    context 'on a bookmark' do
      let (:content) do
        "Book title\n" +
        "- Bookmark on Page 1 | Loc. 406  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "\n"
      end

      it 'marks the clipping as a bookmark' do
        subject[:type].should == :bookmark
      end

      it 'extracts empty text' do
        subject[:text].should == ''
      end
    end

    context 'on a 4th-generation bookmark' do
      let (:content) do
        "Book title\n" +
        "- Your Bookmark on Page 1 | Location 406  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "\n"
      end

      it 'marks the clipping as a bookmark' do
        subject[:type].should == :bookmark
      end

      it 'extracts empty text' do
        subject[:text].should == ''
      end
    end

    context 'on a clipping with a single location value' do
      let (:content) do
        "Book title\n" +
        "- Highlight Loc. 465 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'extracts the location' do
        subject[:location].should == 465
      end

      it 'extracts the added_on date' do
        subject[:added_on].should == 'Thursday, April 21, 2011, 07:31 AM'
      end
    end

    context 'on a 4th-generation clipping with a single location value' do
      let (:content) do
        "Book title\n" +
        "- Your Highlight Location 465 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'extracts the location' do
        subject[:location].should == 465
      end

      it 'extracts the added_on date' do
        subject[:added_on].should == 'Thursday, April 21, 2011, 07:31 AM'
      end
    end

    context 'on a clipping with a location range' do
      let (:content) do
        "Book title\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'extracts the first element of the location range' do
        subject[:location].should == 466
      end

      it 'extracts the added_on date' do
        subject[:added_on].should == 'Thursday, April 21, 2011, 07:31 AM'
      end
    end

    context 'on a 4th-generation clipping with a location range' do
      let (:content) do
        "Book title\n" +
        "- Your Highlight Location 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'extracts the first element of the location range' do
        subject[:location].should == 466
      end

      it 'extracts the added_on date' do
        subject[:added_on].should == 'Thursday, April 21, 2011, 07:31 AM'
      end
    end

    context 'on a highlight with a page number and location range' do
      let (:content) do
        "Book title\n" +
        "- Highlight on Page 171 | Loc. 1858-59  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Some highlighted text\n" +
        "\n"
      end

      it 'extracts the first element of the location range' do
        subject[:location].should == 1858
      end

      it 'extracts the page number' do
        subject[:page].should == 171
      end

      it 'extracts the date' do
        subject[:added_on].should == 'Thursday, April 21, 2011, 07:31 AM'
      end
    end

    context 'on a 4th-generation highlight with a page number and location range' do
      let (:content) do
        "Book title\n" +
        "- Your Highlight on Page 171 | Location 1858-59  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Some highlighted text\n" +
        "\n"
      end

      it 'extracts the first element of the location range' do
        subject[:location].should == 1858
      end

      it 'extracts the page number' do
        subject[:page].should == 171
      end

      it 'extracts the date' do
        subject[:added_on].should == 'Thursday, April 21, 2011, 07:31 AM'
      end
    end

    context 'on a highlight with a page number and no location' do
      let (:content) do
        "Book title\n" +
        "- Highlight on Page 9 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Clipping"
      end

      it 'extracts no location' do
        subject[:location].should be_nil
      end

      it 'extracts the page number' do
        subject[:page].should == 9
      end

      it 'extracts the date' do
        subject[:added_on].should == 'Thursday, April 21, 2011, 07:31 AM'
      end
    end

    context 'on a 4th-generation highlight with a page number and no location' do
      let (:content) do
        "Book title\n" +
        "- Your Highlight on Page 9 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Clipping"
      end

      it 'extracts no location' do
        subject[:location].should be_nil
      end

      it 'extracts the page number' do
        subject[:page].should == 9
      end

      it 'extracts the date' do
        subject[:added_on].should == 'Thursday, April 21, 2011, 07:31 AM'
      end
    end
  end

  describe '#build_clipping_from' do

    let(:it) { Klipbook::ClippingsParser.new }

    context 'with an empty string' do
      subject { it.build_clipping_from("  ") }

      it { should be_nil }
    end

    it 'builds a clipping using the extracted attributes' do
      attributes = {
        title:    'Dummy title',
        type:     :highlight,
        location: 42,
        added_on: '10 August 2011',
        text:     'Some highlighted text'
      }
      stub(it).extract_attributes { attributes }
      stub(Klipbook::Clipping).new

      it.build_clipping_from('Dummy content')

      Klipbook::Clipping.should have_received.new.with(attributes)
    end
  end

  describe "#strip_control_characters" do
    let(:it) { Klipbook::ClippingsParser.new }

    it "removes all carriage return characters" do
      processed_text = it.strip_control_characters("An example \r clippings text\r")
      processed_text.should_not include("\r")
    end

    it "removes all Unicode byte order marks" do
      processed_text = it.strip_control_characters("An example \xef\xbb\xbf clippings text\xef\xbb\xbf")
      processed_text.should_not include("\xef\xbb\xbf")
    end
  end
end


