NewTweetCity::Application.routes.draw do
  root 'snapshots#last'

  resources :hoods, only: [:index, :show]

  scope ':area' do
    resources :snapshots do
      collection do
        get :last
      end
    end
  end

  get 'mockups/:page/(:id)', to: :page, controller: :mockups
end
