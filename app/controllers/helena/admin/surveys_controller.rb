require_dependency 'helena/application_controller'

module Helena
  module Admin
    class SurveysController < Admin::ApplicationController
      respond_to :html

      add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path

      before_filter :resort, only: [:move_up, :move_down, :create]

      def index
        @surveys = Helena::Survey.all
      end

      def new
        add_breadcrumb t('.new')
        @survey = Helena::Survey.new
      end

      def create
        add_breadcrumb t('.new')

        @survey = Helena::Survey.new survey_params
        @survey.position = Helena::Survey.maximum_position + 1
        if @survey.save
          notify_successful_create_for(@survey.name)
        else
          notify_error
        end
        respond_with @survey, location: admin_surveys_path
      end

      def edit
        @survey = Helena::Survey.find params[:id]
        add_breadcrumb @survey.name
      end

      def update
        @survey = Helena::Survey.find params[:id]

        if @survey.update_attributes survey_params
          notify_successful_update_for(@survey.name)
        else
          notify_error
          add_breadcrumb @survey.name_was
        end
        respond_with @survey, location: admin_surveys_path
      end

      def move_up
        @survey = Helena::Survey.find params[:id]

        if @survey.position > 1
          @survey.swap_position @survey.position - 1
          notify_successful_update_for(@survey.name)
        end

        respond_with @survey, location: admin_surveys_path
      end

      def move_down
        @survey = Helena::Survey.find params[:id]

        if @survey.position < Helena::Survey.maximum_position
          @survey.swap_position @survey.position + 1
          notify_successful_update_for(@survey.name)
        end

        respond_with @survey, location: admin_surveys_path
      end

      def destroy
        @survey = Helena::Survey.find(params[:id])
        notify_successful_delete_for(@survey.name) if @survey.destroy
        respond_with @survey, location: admin_surveys_path
      end

      private

      def resort
        Helena::Survey.resort
      end

      def survey_params
        params.require(:survey).permit(:name, :description)
      end
    end
  end
end
