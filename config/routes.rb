Landable::Engine.routes.draw do
  scope path: Landable.configuration.api_namespace, module: 'api' do
    resources :access_tokens, only: [:create, :update, :destroy]
    resources :categories, only: [:index, :show]

    resources :directories, only: [:index, :show], constraints: {
      id: /[%a-zA-Z0-9\/_.~-]*/
    }

    resources :assets, only: [:index, :show, :create, :update]

    concern :has_assets do
      resources :assets, only: [:index, :update, :destroy]
    end

    concern :has_screenshots do
      post 'screenshots', on: :member
    end

    resources :themes, only: [:index, :show, :create, :update], concerns: :has_assets do
      post 'preview', on: :collection
    end

    resources :templates, only: [:index, :show, :create, :update]

    resources :pages, concerns: [:has_assets, :has_screenshots] do
      post 'preview', on: :collection
      post 'publish', on: :member
    end

    resources :page_revisions, only: [:index, :show], concerns: [:has_screenshots] do
      post 'revert_to', on: :member
    end

    resources :screenshots, only: [:index, :show, :create] do
      post 'callback', on: :collection
      post 'resubmit', on: :member
    end

    resources :access_tokens, only: [:create, :destroy, :show]
  end

  scope module: 'public', as: :public do
    scope '-', module: 'preview', as: :preview do
      resources :pages, path: 'p', only: [:show]
      resources :page_revisions, path: 'pr', only: [:show]
    end

    get '*url' => 'pages#show', as: :page, constraints: {
      url: /[a-zA-Z0-9\/_.~-]*/
    }
  end
end
