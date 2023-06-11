require "./lib/percentable"

RSpec.describe Percentable do 
  include Percentable
  it "can calculate percentages accurately" do 

    expect(percentage(4,10).round(2)).to eq(0.40)
    expect(percentage(10,100).round(2)).to eq(0.10)
    expect(percentage(60,82).round(2)).to eq(0.73)
  end
end