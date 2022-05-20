Rails.application.routes.draw do
  mount_devise_token_auth_for 'User',
                              at: 'auth',
                              controllers: {
                                registrations: 'auth/registrations',
                              }
  resources :rooms, only: %i[index show create update destroy] do
    resources :agendas, only: %i[show create update destroy] do
      member { patch :move }
      resources :items, only: %i[create update destroy] do
        member { patch :move }
      end
    end
  end
end
