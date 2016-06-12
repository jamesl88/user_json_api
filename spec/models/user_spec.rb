require 'rails_helper'

describe User do
  describe '#soft_delete' do
    let!(:user) { FactoryGirl.create(:user, deleted_at: nil) }
    before { user.soft_delete! }

    context 'soft_delete' do
      it { expect(user.reload.deleted_at).not_to eq nil }
    end
  end

  describe 'default_scope' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:deleted_user) { FactoryGirl.create(:user, deleted_at: DateTime.now ) }

    it { expect(User.all).to include(user) }
    it { expect(User.all).not_to include(deleted_user) }
  end

  describe 'validations' do
    let!(:user) { FactoryGirl.build(:user) }
    context 'first_name' do
      context 'when valid' do
        before { user.first_name = 'Foo' }
        it { expect(user).to be_valid }
      end

      context 'when invalid' do
        before { user.first_name = nil }
        it { expect(user).not_to be_valid }
      end
    end

    context 'last_name' do
      context 'when valid' do
        before { user.last_name = 'Bar' }
        it { expect(user).to be_valid }
      end

      context 'when invalid' do
        before { user.last_name = nil }
        it { expect(user).not_to be_valid }
      end
    end

    context 'email' do
      context 'when valid' do
        before { user.email = 'foobar@example.com' }
        it { expect(user).to be_valid }
      end

      context 'when invalid' do
        context 'when not present' do
          before { user.email = nil }
          it { expect(user).not_to be_valid }
        end

        context 'when the format is not valid' do
          before { user.email = 'foobar@' }
          it { expect(user).not_to be_valid }
        end
      end
    end

    context 'password' do
      context 'when valid' do
        before { user.password = 'password' }
        it { expect(user).to be_valid }
      end

      context 'when invalid' do
        context 'when not present' do
          before { user.password = nil }
          it { expect(user).not_to be_valid }
        end
      end
    end
  end

  describe "before_create" do
    context 'encrypt_password' do
      let(:user) { FactoryGirl.build(:user, password: 'examplepassword') }

      before do
        stub(SecureRandom).hex { '12345' }
        mock(Digest::SHA1).hexdigest("Add 12345 to examplepassword") { 'encrypted_password' }

        user.save!
      end

      it { expect(user.salt).to eq '12345' }
      it { expect(user.encrypted_password).to eq 'encrypted_password' }
    end
  end
end
