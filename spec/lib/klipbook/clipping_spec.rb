require 'spec_helper'

describe Klipbook::Clipping do
  it 'treats the added_on attribute as a date when created' do
    clipping = Klipbook::Clipping.new(added_on: "Sunday, December 4, 2011, 07:33 AM")
    clipping.added_on.should == DateTime.new(2011,12,4,7,33)
  end

  it 'sort based upon location, treating nils as 0' do
    first_clipping = Klipbook::Clipping.new(location: nil)
    second_clipping = Klipbook::Clipping.new(location: 23)
    third_clipping = Klipbook::Clipping.new(location: 345)

    sorted_clippings = [second_clipping, third_clipping, first_clipping].sort
    sorted_clippings.should  == [ first_clipping, second_clipping, third_clipping ]
  end
end
