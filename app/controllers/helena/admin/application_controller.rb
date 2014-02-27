module Helena
  module Admin
    class ApplicationController < Helena::ApplicationController
      before_filter :authenticate_administrator

      def notify_successful_create_for(resource_name)
        flash[:notice] = t('actions.created', ressource: resource_name)
      end

      def notify_successful_update_for(resource_name)
        flash[:notice] = t('actions.updated', ressource: resource_name)
      end

      def notify_successful_delete_for(resource_name)
        flash[:notice] = t('actions.deleted', ressource: resource_name)
      end

      def notify_error
        flash[:error] = t 'actions.error'
      end
    end
  end
end
