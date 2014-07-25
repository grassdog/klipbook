require 'spec_helper'

RSpec.describe Klipbook::Commands::ListBooks do

  let (:output) do
    double("output", puts: nil)
  end

  describe '#call' do

    subject { Klipbook::Commands::ListBooks.new(books).call(output) }

    context 'when created with no books' do

      let (:books) { [] }

      it 'displays a message saying that the clipping file contains no books' do
        subject
        expect(output).to have_received(:puts).with('No books available')
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
        expect(output).to have_received(:puts).with('Book list:')
      end

      it 'displays an indexed list of book titles including the author when available' do
        subject
        expect(output).to have_received(:puts).with('[1] My first fake title')
        expect(output).to have_received(:puts).with('[2] Another fake book by Rock Riphard')
      end
    end
  end
end
