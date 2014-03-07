module Helena
  module Admin
    class ApplicationController < Helena::ApplicationController
      before_filter :authenticate_administrator
      layout 'helena/admin'

      def notify_successful_create_for(resource_name)
        flash[:notice] = t('actions.created', resource: resource_name)
      end

      def notify_successful_update_for(resource_name)
        flash[:notice] = t('actions.updated', resource: resource_name)
      end

      def notify_successful_delete_for(resource_name)
        flash[:notice] = t('actions.deleted', resource: resource_name)
      end

      def notify_error(resource = nil)
        flash[:error] = []
        if resource

          resource.errors.full_messages.each do |message|
            flash[:error] << message
          end
        else
          flash[:error] << t('actions.error')
        end
      end
    end
  end
end
