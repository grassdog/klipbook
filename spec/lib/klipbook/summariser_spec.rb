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

  describe '#summarise_all_books' do
    subject { Klipbook::Summariser.new(book_source, summary_writer).summarise_all_books(true) }

    context 'with a book source containing two books' do

      let (:book_one) { Klipbook::Book.new }
      let (:book_two) { Klipbook::Book.new }

      let (:books) do
        [ book_one, book_two ]
      end

      it 'passes each book to the summary writer' do
        subject
        summary_writer.should have_received.write(book_one, true)
        summary_writer.should have_received.write(book_two, true)
      end
    end
  end

  describe '#summarise_book' do
    subject { Klipbook::Summariser.new(book_source, summary_writer).summarise_book(book_index, true) }

    context 'with a book source containing two books' do

      let (:book_one) { Klipbook::Book.new }
      let (:book_two) { Klipbook::Book.new }

      let (:books) do
        [ book_one, book_two ]
      end

      context 'and a request to summarise the third book' do
        let(:book_index) { 2 }

        it 'raises an exception' do
          -> { subject }.should raise_error('Sorry there are only 2 books')
        end
      end

      context 'and a request to summarise the second book' do
        let(:book_index) { 1 }

        it 'passes the second book to the summary writer' do
          subject
          summary_writer.should_not have_received.write(book_one, true)
          summary_writer.should have_received.write(book_two, true)
        end
      end
    end
  end

  #describe '#print_book_summary' do

    #describe 'with a clipping files with two books' do
      #let (:book_two) do
        #book_two = Object.new
      #end

      #let (:books) do
        #[ OpenStruct.new(title: 'My first fake title'), book_two ]
      #end

      #[0, 3].each do |book_number|
        #it "displays an error message if the book index requested is #{book_number}" do
          #stub($stderr).puts
          #Klipbook::Runner.new(input_file).print_book_summary(book_number, output)
          #$stderr.should have_received.puts('Sorry but you must specify a book index between 1 and 2')
        #end
      #end

      #it 'outputs the html summary of the book selected' do
        #mock_html_output = Object.new
        #stub(output).write
        #stub(book_two).as_html { mock_html_output }
        #Klipbook::Runner.new(input_file).print_book_summary(2, output)
        #output.should have_received.write(mock_html_output)
      #end
    #end
  #end
end
