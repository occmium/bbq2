require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_for_vkontakte_oauth' do
    # Создаём объект :access_token
    # В него записываем те данные, которые мы доставали их хеша
    let(:access_token) do
      double(
        :access_token,
        provider: 'vkontakte',
        # extra: double(raw_info: double(id: '1')),
        info: double(
          urls: double(Vkontakte: 'http://vk.com/id1'),
          first_name: 'Josef',
          email: 'email@email.email'
        )
      )
    end

    # Ситуация: пользователь не найден
    context 'when user is not found' do
      it 'returns newly created user' do
        user = User.find_for_vkontakte_oauth(access_token)

        expect(user).to be_persisted
        expect(user.email).to eq 'email@email.email'
        expect(user.name).to eq 'Josef'
      end
    end

    # Ситуация: юзер найден по почте
    context 'when user is found by email' do
      let!(:existing_user) { create(:user, email: 'email@email.email') }
      let!(:some_other_user) { create(:user) }

      it 'returns this user' do
        expect(User.find_for_vkontakte_oauth(access_token)).to eq existing_user
      end
    end

    # Ситуация: юзер найден по провайдеру и урлу
    context 'when user is found by provider + url' do
      let!(:existing_user) do
        create(:user, provider: 'vkontakte', url: 'http://vk.com/id1')
      end
      let!(:some_other_uer) { create(:user) }

      it 'returns this user' do
        expect(User.find_for_vkontakte_oauth(access_token)).to eq existing_user
      end
    end
  end
end
