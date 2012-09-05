require 'spec_helper'

describe Klipbook::Collator do

  let (:it) { Klipbook::Collator.new(books, summary_writer) }

  let (:summary_writer) do
    Object.new.tap do |fake_writer|
      stub(fake_writer).write
    end
  end

  let (:message_stream) do
    Object.new.tap do |fake_stream|
      stub(fake_stream).puts
    end
  end

  let (:book_one) { Klipbook::Book.new }
  let (:book_two) { Klipbook::Book.new }
  let (:books) { [ book_one, book_two ] }

  let(:output_dir) { 'fake output dir' }

  describe '#collate_books' do

    subject { it.collate_books(output_dir, true, message_stream) }

    it 'prints a message displaying the output directory' do
      subject
      message_stream.should have_received.puts('Using output directory: fake output dir')
    end

    it 'passes each book to the summary writer' do
      subject
      summary_writer.should have_received.write(book_one, output_dir, true)
      summary_writer.should have_received.write(book_two, output_dir, true)
    end
  end
end
