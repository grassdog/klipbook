require 'spec_helper'

describe Klipbook::Commands::ListBooks do

  let (:output) do
    Object.new.tap do |fake_output|
      stub(fake_output).puts
    end
  end

  describe '#call' do

    subject { Klipbook::Commands::ListBooks.new(books).call(output) }

    context 'when created with no books' do

      let (:books) { [] }

      it 'displays a message saying that the clipping file contains no books' do
        subject
        output.should have_received.puts('No books available')
      end
    end

    context 'when created with multiple books' do
      let (:books) do
        [
          Klipbook::Book.new.tap { |b| b.title = 'My first fake title' },
          Klipbook::Book.new.tap { |b| b.title = 'Another fake book'; b.author = 'Rock Riphard' }
        ]
      end

      it 'displays a message describing the book list' do
        subject
        output.should have_received.puts('Book list:')
      end

      it 'displays an indexed list of book titles including the author when available' do
        subject
        output.should have_received.puts('[1] My first fake title')
        output.should have_received.puts('[2] Another fake book by Rock Riphard')
      end
    end
  end
end
