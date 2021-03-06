Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET_KEY']
  # provider :facebook,
  #          ENV['FACEBOOK_API_KEY'],
  #          ENV['FACEBOOK_API_SECRET_KEY'],
  #          {
  #            image_size: 'square',
  #            callback_url: "#{ENV['VUE_APP_RIVER_APP_URL']}/omniauth/facebook/callback",
  #          }
  provider :google_oauth2,
           ENV['GOOGLE_API_KEY'],
           ENV['GOOGLE_API_SECRET_KEY'],
           {
             scope: 'userinfo.email, userinfo.profile',
             image_aspect_ratio: 'square',
             image_size: 50,
           }
end
OmniAuth.config.allowed_request_methods = %i[post get]
OmniAuth.config.silence_get_warning = true
