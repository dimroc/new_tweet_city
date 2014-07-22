NewTweetCity::Application.routes.draw do
  root 'home#index'

  resources :hoods, only: [:index, :show]
  resources :boroughs, only: [:show]
  resources :hashtags

  resources :frequencies, only: [:show]

  scope ':area' do
    resources :snapshots do
      collection do
        get :last
      end
    end
  end

  get 'mockups/:page/(:id)', to: :page, controller: :mockups
end
