require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/confirm_email' => 'omniauth_callbacks#confirm_email'
  end

  concern :voted do
    member do
      post :vote
      post :unvote
    end
  end

  resources :questions, concerns: :voted do
    resources :comments, defaults: { commentable: 'questions' }
    resources :answers, concerns: :voted do
      put :best, on: :member
    end
    resources :subscriptions, only: [:create, :destroy]
  end

  resources :answers, only: [] do
    resources :comments, defaults: { commentable: 'answers' }
  end

  resources :attachments, only: :destroy

  #post 'search', to: 'search#search'
  match 'search', to: 'search#search', via: :get, as: :search

  namespace :api do
    namespace :v1 do
  resources :profiles, only: :index do
    get :me, on: :collection
  end
  resources :questions, only: [:index, :show, :create] do
    resources :answers, only: [:index, :show, :create], shallow: true
  end
end
end

root to: 'questions#index'

end
