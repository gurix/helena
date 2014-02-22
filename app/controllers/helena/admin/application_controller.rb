module Helena
  module Admin
    class ApplicationController < Helena::ApplicationController
      before_filter :authenticate_administrator!
    end
  end
end
