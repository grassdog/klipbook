require 'spec_helper'

RSpec.describe Klipbook::Commands::ToHtml do

  let (:it) { Klipbook::Commands::ToHtml.new(books, pretty_printer) }

  let (:pretty_printer) do
    double(print_to_file: nil)
  end

  let (:message_stream) do
    double(puts: nil)
  end

  let (:book_one) { Klipbook::Book.new('book one') }
  let (:book_two) { Klipbook::Book.new('book two') }
  let (:books) { [ book_one, book_two ] }

  let(:output_dir) { 'fake output dir' }

  describe '#call' do

    subject { it.call(output_dir, true, message_stream) }

    it 'prints a message displaying the output directory' do
      subject
      expect(message_stream).to have_received(:puts).with('Using output directory: fake output dir')
    end

    it 'passes each book to the pretty printer' do
      subject
      expect(pretty_printer).to have_received(:print_to_file).with(book_one, output_dir, true)
      expect(pretty_printer).to have_received(:print_to_file).with(book_two, output_dir, true)
    end
  end
end
