require 'spec_helper'

describe Klipbook::Summariser do

  let (:book_source) do
    Object.new.tap do |fake_book_source|
      stub(fake_book_source).books { books }
    end
  end

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

  let(:output_dir) { 'fake output dir' }

  describe '#summarise_all_books' do
    subject { Klipbook::Summariser.new(book_source, summary_writer).summarise_all_books(output_dir, true, message_stream) }

    let (:book_one) { Klipbook::Book.new }
    let (:book_two) { Klipbook::Book.new }

    let (:books) { [ book_one, book_two ] }

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

  describe '#summarise_book' do
    subject { Klipbook::Summariser.new(book_source, summary_writer).summarise_book(book_index, output_dir, true) }

    context 'with a book source containing two books' do

      let (:book_one) { Klipbook::Book.new }
      let (:book_two) { Klipbook::Book.new }
      let (:books) { [ book_one, book_two ] }

      context 'and a request to summarise the third book' do
        let(:book_index) { 2 }

        it 'raises an exception' do
          expect { subject }.to raise_error(RuntimeError, 'Invalid book. Please specify a number between 1 and 2.')
        end
      end

      context 'and a request to summarise the second book' do
        let(:book_index) { 1 }

        it 'passes the second book to the summary writer' do
          subject
          summary_writer.should_not have_received.write(book_one, output_dir, true)
          summary_writer.should have_received.write(book_two, output_dir, true)
        end
      end
    end
  end
end
