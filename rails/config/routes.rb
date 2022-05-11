Rails.application.routes.draw do
  mount_devise_token_auth_for 'User',
                              at: 'auth',
                              controllers: {
                                registrations: 'auth/registrations',
                              }
  resorces :rooms, only: %i[index show create update destroy]
end
