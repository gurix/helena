require_dependency 'helena/application_controller'

module Helena
  module Admin
    class SurveysController < Admin::ApplicationController
      respond_to :html

      add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path

      before_filter :sort, only: [:move_up, :move_down, :create]

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

        if @survey.save
          flash[:notice] = t('actions.created', ressource: @survey.name)
        else
          flash[:error] = t 'actions.error'
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
          flash[:notice] = t('actions.updated', ressource: @survey.name)
        else
          flash[:error] = t 'actions.error'
          add_breadcrumb @survey.name_was
        end
        respond_with @survey, location: admin_surveys_path
      end

      def move_up
        @survey = Helena::Survey.find params[:id]

        if @survey.position > 1
          @survey.swap_position @survey.position - 1
          flash[:notice] = t 'actions.updated', ressource: @survey.name
        end

        respond_with @survey, location: admin_surveys_path
      end

      def move_down
        @survey = Helena::Survey.find params[:id]

        if @survey.position < Helena::Survey.maximum(:position)
          @survey.swap_position @survey.position + 1
          flash[:notice] = t 'actions.updated', ressource: @survey.name
        end

        respond_with @survey, location: admin_surveys_path
      end

      def destroy
        @survey = Helena::Survey.find(params[:id])
        flash[:notice] = t('actions.deleted', ressource: @survey.name) if @survey.destroy && sort
        respond_with @survey, location: admin_surveys_path
      end

      private

      def sort
        Helena::Survey.all.each_with_index do | survey, index|
          survey.update_attribute(:position, index + 1)
        end
      end

      def survey_params
        params.require(:survey).permit(:name, :description)
      end
    end
  end
end
