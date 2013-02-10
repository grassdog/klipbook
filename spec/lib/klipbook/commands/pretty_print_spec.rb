require 'spec_helper'

describe Klipbook::Commands::PrettyPrint do

  let (:it) { Klipbook::Commands::PrettyPrint.new(books, pretty_printer) }

  let (:pretty_printer) do
    Object.new.tap do |fake_printer|
      stub(fake_printer).print_to_file
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

  describe '#call' do

    subject { it.call(output_dir, true, message_stream) }

    it 'prints a message displaying the output directory' do
      subject
      message_stream.should have_received.puts('Using output directory: fake output dir')
    end

    it 'passes each book to the pretty printer' do
      subject
      pretty_printer.should have_received.print_to_file(book_one, output_dir, true)
      pretty_printer.should have_received.print_to_file(book_two, output_dir, true)
    end
  end
end
