require_dependency DeviseTokenAuth::Engine.config.root.join('app', 'controllers', 'devise_token_auth', 'application_controller.rb').to_s

class DeviseTokenAuth::ApplicationController
  skip_forgery_protection
end
