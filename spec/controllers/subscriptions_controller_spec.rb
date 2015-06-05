require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
	describe SubscriptionsController do

	  describe 'POST #create' do
	    let(:user) { create :user }
			let(:question) { create :question }

	    context 'Non authenticated user' do
				it 'cannot create subscriptions' do
          expect { post :create, question_id: question, format: :js }.to_not change(Subscription, :count)
        end
      end

      context 'Authenticated user' do
        before { sign_in(user) }

        it 'creates new subscription in db' do
          expect { post :create, question_id: question, format: :js }.to change(Subscription, :count).by 1
        end

        it 'renders create template' do
          post :create, question_id: question, format: :js
          expect(response).to render_template :create
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:user) { create :user }
      let(:question) { create :question }
      let!(:subscription) { create :subscription, question: question, user: user}

      context 'Non authenticated user' do
        it 'cannot delete subscriptions' do
          expect { delete :destroy, question_id: question, id: subscription, format: :js }.to_not change(Subscription, :count)
        end
      end

      context 'when user is authenticated' do
        before { sign_in(user) }

        it 'deletes subscriptions' do
					expect { delete :destroy, question_id: question, id: subscription, format: :js }.to change { Subscription.count }.by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, question_id: question, id: subscription, format: :js
          expect(response).to render_template :destroy
        end
      end
		end
	end
end