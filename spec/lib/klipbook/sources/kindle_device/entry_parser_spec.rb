require 'spec_helper'

describe Klipbook::Sources::KindleDevice::EntryParser do

  describe '#build_entry' do
    subject { Klipbook::Sources::KindleDevice::EntryParser.new.build_entry(entry_text) }

    context 'passed an empty entry' do
      let(:entry_text) { "  " }

      it { should be_nil }
    end

    context 'passed an incomplete entry' do
      let(:entry_text) do
        "Not long enough"
      end

      it { should be_nil }
    end

    context 'passed an entry with the title line "Book title (Author\'s Name)"' do
      let (:entry_text) do
        "Book title (Author's Name)\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight text\n"
      end

      its(:title) { should == 'Book title' }

      its(:author) { should == "Author's Name" }
    end

    context 'passed an entry with the title line "Book title (sub title) (Author\'s Name)"' do
      let (:entry_text) do
        "Book title (sub title) (Author's Name)\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight text\n"
      end

      its(:title) { should == 'Book title (sub title)' }

      its(:author) { should == "Author's Name" }
    end

    context 'passed an entry with the title line "Book title"' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight text\n"
      end

      its(:title) { should == 'Book title' }

      its (:author) { should be_nil }
    end

    context 'passed an entry that is a highlight' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      its(:type) { should == :highlight }

      it 'extracts the highlighted text' do
        subject.text.should == "The first line of the highlight\nThe second line of the highlight"
      end
    end

    context 'passed an entry that is a 4th-generation highlight' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Highlight Location 466-69 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      its(:type) { should == :highlight }

      it 'extracts the highlighted text' do
        subject.text.should == "The first line of the highlight\nThe second line of the highlight"
      end
    end

    context 'passed an entry that is a note' do
      let (:entry_text) do
        "Book title\n" +
        "- Note Loc. 623  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The note text"
      end

      its(:type) { should == :note }

      it 'extracts the note text' do
        subject.text.should == "The note text"
      end
    end

    context 'passed an entry that is a 4th-generation note' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Note Location 623  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The note text"
      end

      its(:type) { should == :note }

      it 'extracts the note text' do
        subject.text.should == "The note text"
      end
    end

    context 'passed an entry with a bookmark' do
      let (:entry_text) do
        "Book title\n" +
        "- Bookmark on Page 1 | Loc. 406  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "\n"
      end

      its(:type) { should == :bookmark }

      its(:text) { should == '' }
    end

    context 'passed an entry with a 4th-generation bookmark' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Bookmark on Page 1 | Location 406  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "\n"
      end

      its(:type) { should == :bookmark }

      its(:text) { should == '' }
    end

    context 'passed an entry with a single location value' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight Loc. 465 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      its(:location) { should == 465 }

      its(:added_on) { should == DateTime.parse('Thursday, April 21, 2011, 07:31 AM') }
    end

    context 'passed a 4th-generation entry with a single location value' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Highlight Location 465 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      its(:location) { should == 465 }

      its(:added_on) { should == DateTime.parse('Thursday, April 21, 2011, 07:31 AM') }
    end

    context 'passed an entry with a location range' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'extracts the first element of the location range' do
        subject.location.should == 466
      end

      its(:added_on) { should == DateTime.parse('Thursday, April 21, 2011, 07:31 AM') }
    end

    context 'passed a 4th-generation entry with a location range' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Highlight Location 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'extracts the first element of the location range' do
        subject.location.should == 466
      end

      its(:added_on) { should == DateTime.parse('Thursday, April 21, 2011, 07:31 AM') }
    end

    context 'passed an entry with a page number and location range' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight on Page 171 | Loc. 1858-59  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Some highlighted text\n" +
        "\n"
      end

      it 'extracts the first element of the location range' do
        subject.location.should == 1858
      end

      its(:page) { should == 171 }

      its(:added_on) { should == DateTime.parse('Thursday, April 21, 2011, 07:31 AM') }
    end

    context 'passed a 4th-generation entry with a page number and location range' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Highlight on Page 171 | Location 1858-59  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Some highlighted text\n" +
        "\n"
      end

      it 'extracts the first element of the location range' do
        subject.location.should == 1858
      end

      its(:page) { should == 171 }

      its(:added_on) { should == DateTime.parse('Thursday, April 21, 2011, 07:31 AM') }
    end

    context 'passed an entry with a page number and no location' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight on Page 9 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Clipping"
      end

      its(:location) { should be_nil }

      its(:page) { should == 9 }

      its(:added_on) { should == DateTime.parse('Thursday, April 21, 2011, 07:31 AM') }
    end

    context 'passed a 4th-generation entry with a page number and no location' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Highlight on Page 9 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Clipping"
      end

      its(:location) { should be_nil }

      its(:page) { should == 9 }

      its(:added_on) { should == DateTime.parse('Thursday, April 21, 2011, 07:31 AM') }
    end
  end
end
