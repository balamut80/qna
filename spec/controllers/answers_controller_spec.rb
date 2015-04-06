require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:answer) { create(:answer, question: question, user: @user) }

    it 'assings the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body'}, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'PATCH #best' do
    sign_in_user
    let!(:other_user) { create :user }
    let!(:question) { create :question, user: @user }
    let!(:other_question) { create :question, user: other_user }

    let!(:other_user_answer) { create(:answer, question: question, user: other_user) }
    let!(:user_answer) { create(:answer, question: question, user: @user) }

    let!(:other_question_other_user_answer) { create(:answer, question: other_question, user: other_user) }
    let!(:other_question_user_answer) { create(:answer, question: other_question, user: @user) }

    context 'question author' do

      before do
        patch :best, id: other_user_answer, question_id: question, format: :js
      end

      it 'sets the best answer' do
        other_user_answer.reload
        expect(other_user_answer).to be_best
      end

      it 'renders best template' do
        expect(response).to render_template :best
      end
    end

    context 'other user question' do
      before do
        patch :best, id: other_question_other_user_answer, question_id: other_question, format: :js
      end

      it 'can\'t make best answer' do
        other_question_other_user_answer.reload
        expect(other_question_other_user_answer).not_to be_best
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:answer) { create(:answer, question: question, user: @user) }
    let!(:others_answer) { create(:answer, question: question) }

    it 'deletes his answer' do
      expect { delete :destroy, question_id: question, id: answer, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'deletes other user answer' do
      expect { delete :destroy, question_id: question, id: others_answer, format: :js }.to_not change(Answer, :count)
    end

    it 'redirects to index view' do
      delete :destroy, question_id: question, id: answer, format: :js
      expect(response).to render_template :destroy
    end
  end
end