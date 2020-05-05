require "rails_helper"

describe Phone do
  let(:contact) { Contact.create(firstname: "Janusz", lastname: "Kowalski", email: "test@example.com") }
  let(:phone) { contact.phones.create(phone_type: "home", phone: "123-123-1234") }

  it "does not allow duplicate phone numbers per contact" do
    mobile_phone = contact.phones.build(phone_type: "mobile", phone: phone.phone)

    expect(mobile_phone).not_to be_valid
    expect(mobile_phone.errors[:phone]).to include("has already been taken")
  end

  it "allows two contacts to share a phone number" do
    other_contact = Contact.new
    other_phone = other_contact.phones.build(phone_type: "home", phone: phone.phone)

    expect(other_phone).to be_valid
  end
end
