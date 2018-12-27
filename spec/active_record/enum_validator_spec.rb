# frozen_string_literal: true

RSpec.describe ActiveRecord::PostgresEnum::EnumValidator do
  subject { Track.new }

  it "rejects wrong values" do
    subject.update(mood: "calm")

    expect(subject.errors).to be_key(:mood)
    expect(subject.errors[:mood].first).to eq "Invalid enum value"
  end

  it "accepts nil value" do
    expect(subject.update(mood: nil)).to be true
  end

  it "accepts valid value" do
    expect(subject.update(mood: "happy")).to be true
  end
end
