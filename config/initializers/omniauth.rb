OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, APP_CONFIG['FACEBOOK_APP_ID'], APP_CONFIG['FACEBOOK_SECRET'], 
          scope: "email, publish_stream, manage_pages", display: 'popup'
end