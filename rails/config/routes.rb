Rails.application.routes.draw do
  mount_devise_token_auth_for 'User',
                              at: 'auth',
                              controllers: {
                                registrations: 'auth/registrations',
                              }
  resources :rooms, only: %i[index show create update destroy] do
    resources :agendas, only: %i[index create update destroy]
  end
end
