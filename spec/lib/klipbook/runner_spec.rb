require 'spec_helper'

describe Klipbook::Runner do

  let (:input_file) do
    input_file = Object.new
    stub(input_file).read { '' }
    input_file
  end

  let (:output) do
    output = Object.new
    stub(output).puts
    output
  end

  let (:clippings_file) do
    clipplings = Object.new
    stub(clipplings).books { books }
    clipplings
  end

  before :each do
    stub(Klipbook::Sources::KindleDevice::File).new { clippings_file }
  end

  describe '#list_books' do

    subject { Klipbook::Runner.new(input_file).list_books(output) }

    context 'with an empty clippings file' do

      let (:books) { [] }

      it 'displays a message saying that the clipping file contains no books' do
        subject
        output.should have_received.puts('Your clippings file contains no books')
      end
    end

    context 'with a clipping file with multiple books' do
      let (:books) do
        [ OpenStruct.new(title: 'My first fake title'), OpenStruct.new(title: 'Another fake book', author: 'Rock Riphard') ]
      end

      it 'displays a message describing the book list' do
        subject
        output.should have_received.puts('The list of books in your clippings file:')
      end

      it 'displays an indexed list of book titles including the author when available' do
        subject
        output.should have_received.puts('[1] My first fake title')
        output.should have_received.puts('[2] Another fake book by Rock Riphard')
      end
    end
  end

  describe '#print_book_summary' do

    describe 'with a clipping files with two books' do
      let (:book_two) do
        book_two = Object.new
      end

      let (:books) do
        [ OpenStruct.new(title: 'My first fake title'), book_two ]
      end

      [0, 3].each do |book_number|
        it "displays an error message if the book index requested is #{book_number}" do
          stub($stderr).puts
          Klipbook::Runner.new(input_file).print_book_summary(book_number, output)
          $stderr.should have_received.puts('Sorry but you must specify a book index between 1 and 2')
        end
      end

      it 'outputs the html summary of the book selected' do
        mock_html_output = Object.new
        stub(output).write
        stub(book_two).as_html { mock_html_output }
        Klipbook::Runner.new(input_file).print_book_summary(2, output)
        output.should have_received.write(mock_html_output)
      end
    end
  end
end
