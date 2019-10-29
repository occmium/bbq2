require 'spec_helper'
require 'rails_helper'

RSpec.describe EventPolicy do
  # let(:user) { User.new }
  let(:user) { FactoryBot.create(:user) }
  let(:user_else) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event, user: user) }
  let(:event_pincode) { FactoryBot.create(:event, user: user, pincode: '111') }

  subject { described_class }

  context 'when authorized user' do
    permissions :edit?, :update?, :destroy? do
      it { is_expected.to permit(user, event) }
    end
  end

  context 'when non authorized user' do
    permissions :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(user_else, event) }
    end
  end

  context 'when non authenticated user (visitor)' do
    permissions :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(nil, event) }
    end
  end

  context 'user can look event' do
    context 'when pincode is empty' do
      permissions :show? do
        it { is_expected.to permit(user, event) }
      end
    end

    context 'when pincode is present' do
      permissions :show? do
        it { is_expected.to permit(user, event_pincode) }
      end
    end
  end


  # permissions ".scope" do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end
  #
  # permissions :show? do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end
  #
  # permissions :create? do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end
  #
  # permissions :update? do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end
  #
  # permissions :destroy? do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end
end
