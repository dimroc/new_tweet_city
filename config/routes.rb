NewTweetCity::Application.routes.draw do
  root 'snapshots#last'

  scope ':area' do
    resources :snapshots do
      collection do
        get :last
      end
    end
  end

  get 'mockups/:page/(:id)', to: :page, controller: :mockups
end
