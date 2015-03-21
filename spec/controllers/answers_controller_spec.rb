require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:others_answer) { create(:answer, question: question) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question, id: answer }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before {
      answer
      others_answer
    }

    it 'deletes his answer' do
      expect { delete :destroy, question_id: question, id: answer }.to change(Answer, :count).by(-1)
    end

    it 'deletes other user answer' do
      expect { delete :destroy, question_id: question, id: others_answer }.to_not change(Answer, :count)
    end

    it 'redirects to index view' do
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to question_path(question)
    end
  end
end