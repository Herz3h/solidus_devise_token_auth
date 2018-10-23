# frozen_string_literal: true

Rails.application.configure do
  # this fixes the cookieoverflow errors without disabling cookies
  # which the user might want to use in non-api controllers
  config.action_dispatch.cookies_serializer = :json
end
