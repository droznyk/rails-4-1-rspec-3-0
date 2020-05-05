require "rails_helper"

describe Contact do
  describe "validations" do
    let(:contact) { Contact.new(firstname: "Janusz", lastname: "Kowalski", email: "test@example.com") }
    let(:contact_2) { Contact.new(firstname: "Grażyna", lastname: "Kowalska", email: "test@example.com") }

    it "is valid with a firstname, lastname and email" do
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

      expect(contact_2).not_to be_valid
      expect(contact_2.errors[:email]).to include("has already been taken")
    end

    it "returns a contact's full name as a string" do
      expect(contact.name).to eq "Janusz Kowalski"
    end
  end

  describe "self.by_letter" do
    let(:kowalski) { Contact.create(firstname: "Janusz", lastname: "Kowalski", email: "test1@example.com") }
    let(:mieczka) { Contact.create(firstname: "Amadeusz", lastname: "Mieczka", email: "test2@example.com") }
    let(:mrzonka) { Contact.create(firstname: "Kryspin", lastname: "Mrzonka", email: "test3@example.com") }

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
