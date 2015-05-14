require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question) { create(:question, user: @user) }
    let!(:others_question) { create(:question) }

    it 'deletes his question' do
      expect { delete :destroy, id: question, format: :js  }.to change(Question, :count).by(-1)
    end

    it 'deletes other user question' do
      expect { delete :destroy, id: others_question, format: :js  }.to_not change(Question, :count)
    end

    it 'redirect to index view' do
      delete :destroy, id: question, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'POST #vote' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:other_user) { create(:user) }

    context 'question non-author' do
      before { sign_in(other_user) }

      it 'likes question' do
        expect { post :vote, id: question, value: 1, format: :json }.to change(question.votes, :count).by(1)
      end

      it 'dislikes question' do
        expect { post :vote, id: question, value: -1, format: :json }.to change(question.votes, :count).by(1)
      end
    end

    context 'question author' do
      before { sign_in(user) }

      it 'can\'t vote question' do
        expect { post :vote, id: question, value: 1, format: :json }.not_to change(question.votes, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #unvote' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_user) { create(:user) }

    context 'question non-author' do
      before {
        sign_in(other_user)
        create(:vote, user_id: other_user.id, votable_id: question.id, votable_type: question.class.name)
      }

      it 'unvote question' do
        expect { post :unvote, id: question, format: :json}.to change(question.votes, :count).by(-1)
      end
    end

    context 'question author' do
      before { sign_in(user) }

      it 'can\'t unvote question' do
        expect { post :unvote, id: question, format: :json }.not_to change(question.votes, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end

  end
end

