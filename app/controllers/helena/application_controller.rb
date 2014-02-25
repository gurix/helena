module Helena
  class ApplicationController < ::ApplicationController
    helper_method :can_administer?

    def authenticate_administrator
      fail(ActionController::RoutingError, 'Access Denied') unless can_administer?
    end
  end
end
