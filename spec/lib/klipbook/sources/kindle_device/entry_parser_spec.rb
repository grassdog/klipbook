require 'spec_helper'

RSpec.describe Klipbook::Sources::KindleDevice::EntryParser do

  describe '#build_entry' do
    subject { Klipbook::Sources::KindleDevice::EntryParser.new.build_entry(entry_text) }

    context 'passed an empty entry' do
      let(:entry_text) { "  " }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'passed an incomplete entry' do
      let(:entry_text) do
        "Not long enough"
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'passed an entry with the title line "Book title (Author\'s Name)"' do
      let (:entry_text) do
        "Book title (Author's Name)\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight text\n"
      end

      it 'extracts the title' do
        expect(subject.title).to eq 'Book title'
      end

      it 'extracts the author' do
        expect(subject.author).to eq "Author's Name"
      end
    end

    context 'passed an entry with the title line "Book title (sub title) (Author\'s Name)"' do
      let (:entry_text) do
        "Book title (sub title) (Author's Name)\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight text\n"
      end

      it 'extracts the title containing parens' do
        expect(subject.title).to eq 'Book title (sub title)'
      end

      it 'extracts the author' do
        expect(subject.author).to eq "Author's Name"
      end
    end

    context 'passed an entry with the title line "Book title"' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Highlight text\n"
      end

      it 'extracts the title' do
        expect(subject.title).to eq 'Book title'
      end

      it 'sets author to nil' do
        expect(subject.author).to be_nil
      end
    end

    context 'passed an entry that is a highlight' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight Loc. 466-69  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'returns a highlight' do
        expect(subject.type).to eq :highlight
      end

      it 'extracts the highlighted text' do
        expect(subject.text).to eq "The first line of the highlight\nThe second line of the highlight"
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

      it 'returns a highlight' do
        expect(subject.type).to eq :highlight
      end

      it 'extracts the highlighted text' do
        expect(subject.text).to eq "The first line of the highlight\nThe second line of the highlight"
      end
    end

    context 'passed an entry that is a note' do
      let (:entry_text) do
        "Book title\n" +
        "- Note Loc. 623  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The note text"
      end

      it 'returns a note' do
        expect(subject.type).to eq :note
      end

      it 'extracts the note text' do
        expect(subject.text).to eq "The note text"
      end
    end

    context 'passed an entry that is a 4th-generation note' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Note Location 623  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The note text"
      end

      it 'returns a note' do
        expect(subject.type).to eq :note
      end

      it 'extracts the note text' do
        expect(subject.text).to eq "The note text"
      end
    end

    context 'passed an entry with a bookmark' do
      let (:entry_text) do
        "Book title\n" +
        "- Bookmark on Page 1 | Loc. 406  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "\n"
      end

      it 'returns a bookmark' do
        expect(subject.type).to eq :bookmark
      end

      it 'extracts empty text' do
        expect(subject.text).to eq ""
      end
    end

    context 'passed an entry with a 4th-generation bookmark' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Bookmark on Page 1 | Location 406  | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "\n"
      end

      it 'returns a bookmark' do
        expect(subject.type).to eq :bookmark
      end

      it 'extracts empty text' do
        expect(subject.text).to eq ""
      end
    end

    context 'passed an entry with a single location value' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight Loc. 465 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'returns the correct location' do
        expect(subject.location).to eq 465
      end

      it 'returns the correct added date' do
        expect(subject.added_on).to eq DateTime.parse('Thursday, April 21, 2011, 07:31 AM')
      end
    end

    context 'passed a 4th-generation entry with a single location value' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Highlight Location 465 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "The first line of the highlight\n" +
        "The second line of the highlight"
      end

      it 'returns the correct location' do
        expect(subject.location).to eq 465
      end

      it 'returns the correct added date' do
        expect(subject.added_on).to eq DateTime.parse('Thursday, April 21, 2011, 07:31 AM')
      end
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
        expect(subject.location).to eq 466
      end

      it 'returns the correct added date' do
        expect(subject.added_on).to eq DateTime.parse('Thursday, April 21, 2011, 07:31 AM')
      end
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
        expect(subject.location).to eq 466
      end

      it 'returns the correct added date' do
        expect(subject.added_on).to eq DateTime.parse('Thursday, April 21, 2011, 07:31 AM')
      end
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
        expect(subject.location).to eq 1858
      end

      it 'extracts the page number' do
        expect(subject.page).to eq 171
      end

      it 'returns the correct added date' do
        expect(subject.added_on).to eq DateTime.parse('Thursday, April 21, 2011, 07:31 AM')
      end
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
        expect(subject.location).to eq 1858
      end

      it 'extracts the page number' do
        expect(subject.page).to eq 171
      end

      it 'returns the correct added date' do
        expect(subject.added_on).to eq DateTime.parse('Thursday, April 21, 2011, 07:31 AM')
      end
    end

    context 'passed an entry with a page number and no location' do
      let (:entry_text) do
        "Book title\n" +
        "- Highlight on Page 9 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Clipping"
      end

      it 'sets location to 0' do
        expect(subject.location).to eq 0
      end

      it 'extracts the page number' do
        expect(subject.page).to eq 9
      end

      it 'returns the correct added date' do
        expect(subject.added_on).to eq DateTime.parse('Thursday, April 21, 2011, 07:31 AM')
      end
    end

    context 'passed a 4th-generation entry with a page number and no location' do
      let (:entry_text) do
        "Book title\n" +
        "- Your Highlight on Page 9 | Added on Thursday, April 21, 2011, 07:31 AM\n" +
        "\n" +
        "Clipping"
      end

      it 'sets location to 0' do
        expect(subject.location).to eq 0
      end

      it 'extracts the page number' do
        expect(subject.page).to eq 9
      end

      it 'returns the correct added date' do
        expect(subject.added_on).to eq DateTime.parse('Thursday, April 21, 2011, 07:31 AM')
      end
    end
  end
end
