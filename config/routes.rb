NewTweetCity::Application.routes.draw do
  root 'snapshots#last'
  resources :snapshots do
    collection do
      get :last
    end
  end
end
