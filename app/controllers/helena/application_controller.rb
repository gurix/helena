module Helena
  class ApplicationController < ActionController::Base
    def authenticate_administrator!
      fail(Helena::AccessDenied, 'cannot administer') unless can_administer?
    end
  end
end
