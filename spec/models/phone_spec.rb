require "rails_helper"

describe Phone do
  let(:phone) { create(:phone) }

  it "does not allow duplicate phone numbers per contact" do
    mobile_phone = build(:mobile_phone, contact: phone.contact, phone: phone.phone)

    expect(mobile_phone).not_to be_valid
    expect(mobile_phone.errors[:phone]).to include("has already been taken")
  end

  it "allows two contacts to share a phone number" do
    other_phone = build(:home_phone, phone: phone.phone)

    expect(other_phone).to be_valid
  end
end
