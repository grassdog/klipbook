require 'spec_helper'

describe Klipbook::BookSummary do
  describe '#clippings' do
    subject { Klipbook::BookSummary.new('fake title', 'fake author', clippings).clippings }

    let(:first_clipping) { FakeClipping.new(order: 10) }
    let(:second_clipping) { FakeClipping.new(order: 22) }
    let(:third_clipping) { FakeClipping.new(order: 200) }

    let(:clippings) do
      [
        third_clipping,
        second_clipping,
        first_clipping
      ]
    end

    it 'provides clippings in sorted order' do
      subject.should == [ first_clipping, second_clipping, third_clipping ]
    end
  end

  # A fake clipping that will naturally sort even if the order attribute isn't set
  class FakeClipping < OpenStruct
    def <=>(other)
      self.order <=> other.order
    end
  end
end
