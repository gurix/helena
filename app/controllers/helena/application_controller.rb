module Helena
  class ApplicationController < ::ApplicationController
    helper Helena::Engine.helpers

    helper_method :can_administer?

    def authenticate_administrator
      fail(ActionController::RoutingError, 'Access Denied') unless can_administer?
    end

    def add_breadcrumb(name, path = nil, options = {})
      super(name.presence || t('shared.untitled'), path, options)
    end
  end
end
