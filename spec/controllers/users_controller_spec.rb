describe UsersController do
  describe "user access" do
    let(:user) { create :user }

    before { session[:user_id] = user.id }

    describe "GET #index" do
      it "collects users into @users" do
        another_user = create :user
        get :index

        expect(assigns(:users)).to match_array [user, another_user]
      end

      it "renders index template" do
        get :index

        expect(response).to render_template :index
      end
    end

    describe "GET #new" do
      it "denies access" do
        get :new

        expect(response).to redirect_to root_url
      end
    end

    describe "POST #create" do
      it "denies access" do
        post :user, user: attributes_for(:user)

        expect(response).to redirect_to root_url
      end
    end
  end
end
