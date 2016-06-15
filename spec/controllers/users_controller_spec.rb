require 'rails_helper'

describe UsersController do
  describe 'GET index' do
    let!(:user) { FactoryGirl.create(:user) }

    before { get :index }

    it { expect(response).to be_success }
  end

  describe 'POST create' do
    context 'success' do
      let(:params) do
        {
          "user" => {
            "first_name" => "James",
            "last_name" => "Lieu",
            "email" => "james.lieu@gmail.com",
            "password" => "somepassword"
          }
        }
      end

      context 'creates a new user' do
        it { expect{post :create, params}.to change(User, :count) }
      end

      before { post :create, params }

      it { expect(User.last.first_name).to eq 'James' }
      it { expect(User.last.last_name).to eq 'Lieu' }
      it { expect(User.last.email).to eq 'james.lieu@gmail.com' }
      it { expect(User.last.salt).to be_present }
      it { expect(User.last.encrypted_password).to be_present }
    end

    context 'failed' do
      let(:params) do
        {
          "user" => {
            "first_name" => "James",
            "last_name" => "Lieu",
            "password" => "somepassword"
          }
        }
      end

      context 'does not to create a new user' do
        it { expect{post :create, params}.not_to change(User, :count) }
      end

      it "returns a error message" do
        post :create, params
        expect(JSON.parse(response.body)).to eq("email" => ["can't be blank", "is invalid"])
      end
    end
  end

  describe "PATCH update" do
    let!(:user) do
      FactoryGirl.create(:user,
        first_name: 'James',
        last_name: 'Lieu',
        email: 'james.lieu@gmail.com'
      )
    end

    let(:params) do
      { "id" => user.id,
        "user" => {
          "email" => "james.lieu@gmail.com",
          "first_name" => "Kelvin",
          "last_name" => "Smith",
          "password" => "somepassword"
        }
      }
    end

    context 'success' do
      context 'when submitted with authenticated password?' do
        before do
          stub(controller).authenticated_password? { true }
          put :update, params
        end

        it { expect(user.reload.first_name).to eq 'Kelvin' }
        it { expect(user.reload.last_name).to eq 'Smith' }
      end

      context 'when submitted with unauthenticated password?' do
        before do
          stub(controller).authenticated_password? { false }
          put :update, params
        end

        it { expect(user.reload.first_name).to eq 'James' }
        it { expect(user.reload.last_name).to eq 'Lieu' }
      end
    end

    context 'failed' do
      before do
        stub(controller).authenticated_password? { true }
        stub(user).save { false }
        put :update, params
      end

      it { expect(user.reload.first_name).to eq 'James' }
      it { expect(user.reload.last_name).to eq 'Lieu' }
      it { expect(response.status).to eq 401 }
    end
  end

  describe 'destroy' do
    let!(:user) do
      FactoryGirl.create(:user,
        first_name: 'James',
        last_name: 'Lieu',
        email: 'james.lieu@gmail.com',
        deleted_at: nil
      )
    end

    let(:params) do
      { "id" => user.id,
        "user" => {
          "email" => "james.lieu@gmail.com",
          "password" => "somepassword"
        }
      }
    end

    context 'success' do
      context 'when submitted with authenticated password?' do
        before do
          stub(controller).authenticated_password? { true }
          delete :destroy, params
        end

        it { expect(user.reload.deleted_at).to be_present }
      end

      context 'when submitted with unauthenticated password?' do
        before do
          stub(controller).authenticated_password? { false }
          put :update, params
        end

        it { expect(user.reload.deleted_at).not_to be_present }
      end
    end

    context 'failed' do
      before do
        stub(controller).authenticated_password? { true }
        stub(user).save { false }
        put :update, params
      end

      it { expect(user.reload.deleted_at).not_to be_present }
      it { expect(response.status).to eq 401 }
    end
  end
end
