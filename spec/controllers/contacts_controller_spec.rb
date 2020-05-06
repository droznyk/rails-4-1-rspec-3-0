require "rails_helper"

describe ContactsController do
  shared_examples "public access to contacts" do
    describe 'GET #index' do
      let(:kowalski) { create(:contact, lastname: "Kowalski") }
      let(:pietrasiewicz) { create(:contact, lastname: "Pietrasiewicz") }

      context 'with params[:letter]' do
        it "populates an array of contacts starting with the letter" do
          get :index, letter: "P"

          expect(assigns(:contacts)).to match_array([pietrasiewicz])
        end

        it "renders the :index template" do
          get :index, letter: "P"

          expect(response).to render_template :index
        end
      end

      context 'without params[:letter]' do
        it "populates an array of all contacts" do
          get :index

          expect(assigns(:contacts)).to match_array([kowalski, pietrasiewicz])
        end

        it "renders the :index template" do
          get :index

          expect(response).to render_template :index
        end
      end
    end

    describe "GET #show" do
      let(:contact) { create :contact }

      it "assigns the requested contact to @contact" do
        get :show, id: contact

        expect(assigns(:contact)).to eq contact
      end

      it "renders the :show template" do
        get :show, id: contact

        expect(response).to render_template :show
      end
    end
  end

  shared_examples "full access to contacts" do
    describe 'GET #new' do
      it "assigns a new Contact to @contact" do
        get :new

        expect(assigns(:contact)).to be_a_new(Contact)
      end

      it "renders the :new template" do
        get :new

        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      let(:contact) { create :contact }

      it "assigns the requested contact to @contact" do
        get :edit, id: contact

        expect(assigns(:contact)).to eq contact
      end

      it "renders the :edit template" do
        get :edit, id: contact

        expect(response).to render_template :edit
      end
    end

    describe "POST #create" do
      let(:phones) { Array.new(3) { attributes_for(:phone) } }

      context "with valid attributes" do
        it "saves the new contact in the database" do
          expect { post :create, contact: attributes_for(:contact, phones_attributes: phones) }.to change(Contact, :count).by(1)
        end

        it "redirects to contacts#show" do
          post :create, contact: attributes_for(:contact, phones_attributes: phones)

          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end

      context "with invalid attributes" do
        it "does not save the new contact in the database" do
          expect { post :create, contact: attributes_for(:invalid_contact) }.not_to change(Contact, :count)
        end

        it "re-renders the :new template" do
          post :create, contact: attributes_for(:invalid_contact)

          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      let(:contact) { create :contact, firstname: "John", lastname: "Doe" }

      context "with valid attributes" do
        it "locates the requested contact" do
          patch :update, id: contact, contact: attributes_for(:contact)

          expect(assigns(:contact)).to eq contact
        end

        it "changes the contact's attributes" do
          patch :update, id: contact, contact: attributes_for(:contact, firstname: "Jan", lastname: "Kowalski")
          contact.reload

          expect(contact.firstname).to eq "Jan"
          expect(contact.lastname).to eq "Kowalski"
        end

        it "redirects to the updated contact" do
          patch :update, id: contact, contact: attributes_for(:contact)

          expect(response).to redirect_to contact
        end
      end

      context "with invalid attributes" do
        it "does not change the contact's attributes" do
          patch :update, id: contact, contact: attributes_for(:contact, firstname: "Jan", lastname: nil)
          contact.reload

          expect(contact.firstname).not_to eq "Jan"
          expect(contact.lastname).to eq "Doe"
        end

        it "re-renders the :edit template" do
          patch :update, id: contact, contact: attributes_for(:invalid_contact)

          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:contact) { create :contact }

      it "deletes the contact from the database" do
        expect { delete(:destroy, id: contact) }.to change(Contact, :count).by(-1)
      end

      it "redirects to users#index" do
        delete(:destroy, id: contact)

        expect(response).to redirect_to contacts_url
      end
    end
  end

  describe "administrator access" do
    let(:admin) { create :admin }

    before { session[:user_id] = admin.id }

    it_behaves_like "public access to contacts"
    it_behaves_like "full access to contacts"
  end

  describe "user access" do
    let(:user) { create :user }

    before { session[:user_id] = user.id }

    it_behaves_like "public access to contacts"
    it_behaves_like "full access to contacts"
  end

  describe "guest access" do
    it_behaves_like "public access to contacts"

    describe "GET #edit" do
      let(:contact) { create :contact }

      it "requires login" do
        get :edit, id: contact

        expect(response).to redirect_to login_url
      end
    end

    describe "POST #create" do
      it "requires login" do
        post :create, contact: attributes_for(:contact)

        expect(response).to redirect_to login_url
      end
    end

    describe "PATCH #update" do
      let(:contact) { create :contact }

      it "requires login" do
        patch :update, id: contact, contact: attributes_for(:contact)

        expect(response).to redirect_to login_url
      end
    end

    describe "DELETE #destroy" do
      let(:contact) { create :contact }

      it "requires login" do
        delete(:destroy, id: contact)

        expect(response).to redirect_to login_url
      end
    end
  end
end
