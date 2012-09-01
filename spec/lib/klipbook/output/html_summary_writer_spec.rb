require 'spec_helper'

# This is more of an integration test but what the heck
# it can live in here for now

describe Klipbook::Output::HtmlSummaryWriter do

  before(:all) do
    @output_dir = Dir.mktmpdir
  end

  after(:all) do
    FileUtils.rm_f(@output_dir)
  end

  let(:book) do
    Klipbook::Book.new do |b|
      b.title = 'Fake book title'
      b.author = 'Fake Author'
      b.clippings = []
    end
  end

  let(:message_stream) do
    Object.new.tap do |fake_stream|
      stub(fake_stream).puts
    end
  end

  describe '#write' do

    subject { Klipbook::Output::HtmlSummaryWriter.new(@output_dir, message_stream).write(book, force) }

    let(:force) { false }

    let(:expected_filename) { "#{@output_dir}/Fake book title by Fake Author.html" }

    context 'with no existing summary file' do
      before(:each) do
        FileUtils.rm_f(File.join(@output_dir, '*'))
      end

      it 'writes a file named after the book into the output directory' do
        subject
        File.exists?(expected_filename).should be_true
      end

      it 'writes a html summary to the file' do
        subject
        File.read(expected_filename).should include("<h1>Fake book title</h1>")
      end
    end

    context 'with an existing summary file' do
      before(:each) do
        FileUtils.rm_f(expected_filename)
        FileUtils.touch(expected_filename)
      end

      context "and 'force' set to false" do
        let(:force) { false }

        it "won't write to the file" do
          subject
          File.size(expected_filename).should == 0
        end

        it 'prints a warning message' do
          subject
          message_stream.should have_received.puts("Skipping existing summary file: #{expected_filename}")
        end
      end

      context "and 'force' set to true" do
        let(:force) { true }

        it 'will overwrite the file' do
          subject
          File.size(expected_filename).should > 0
        end
      end
    end
  end
end
