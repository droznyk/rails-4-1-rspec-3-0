require "rails_helper"

describe Contact do
  describe "validations" do
    let(:contact) { build(:contact) }

    it "has a valid factory" do
      expect(contact).to be_valid
    end

    it "is invalid without a firstname" do
      contact.firstname = nil

      expect(contact).not_to be_valid
      expect(contact.errors[:firstname]).to include("can't be blank")
    end

    it "is invalid without a lastname" do
      contact.lastname = nil

      expect(contact).not_to be_valid
      expect(contact.errors[:lastname]).to include("can't be blank")
    end

    it "is invalid without an email address" do
      contact.email = nil

      expect(contact).not_to be_valid
      expect(contact.errors[:email]).to include("can't be blank")
    end

    it "is invalid with a duplicate email address" do
      contact.save
      contact_2 = build(:contact, email: contact.email)

      expect(contact_2).not_to be_valid
      expect(contact_2.errors[:email]).to include("has already been taken")
    end

    it "returns a contact's full name as a string" do
      expect(contact.name).to eq [contact.firstname, contact.lastname].join(" ")
    end

    it "has three phone numbers" do
      contact.save

      expect(contact.phones.count).to eq 3
    end
  end

  describe "self.by_letter" do
    let(:kowalski) { create(:contact, lastname: "Kowalski") }
    let(:mieczka) { create(:contact, lastname: "Mieczka") }
    let(:mrzonka) { create(:contact, lastname: "Mrzonka") }

    context "with matching letters" do
      it "returns a sorted array of results that match" do
        expect(Contact.by_letter("M")).to eq [mieczka, mrzonka]
      end
    end

    context "with non-matching letters" do
      it "omits results that do not match" do
        expect(Contact.by_letter("M")).not_to include(kowalski)
      end
    end
  end
end
