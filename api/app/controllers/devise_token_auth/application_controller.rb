module DeviseTokenAuth
  class ApplicationController < DeviseController
    skip_forgery_protection
  end
end
