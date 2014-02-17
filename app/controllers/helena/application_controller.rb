module Helena
  class ApplicationController < ActionController::Base
    def authenticate_administrator!
      unless can_administer?
        raise Helena::AccessDenied.new("cannot administer")
      end
    end
  end
end
