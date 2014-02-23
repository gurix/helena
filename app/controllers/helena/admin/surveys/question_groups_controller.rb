require_dependency 'helena/application_controller'

module Helena
  module Admin
    module Surveys
      class QuestionGroupsController < Admin::ApplicationController
        respond_to :html

        before_filter :load_survey, :add_breadcrumps

        def index
          @question_groups = @survey.question_groups
        end

        def new
          add_breadcrumb t('.new')
          biggest_question_group_position = @survey.question_groups.maximum(:position) || 0
          @question_group = @survey.question_groups.new survey: @survey, position: (biggest_question_group_position + 1)
        end

        def create
          add_breadcrumb t('.new')

          @question_group = @survey.question_groups.new question_group_params

          if @question_group.save
            flash[:notice] = t('actions.created', ressource: @question_group.title)
          else
            flash[:error] = t 'actions.error'
          end
          respond_with @question_group, location: admin_survey_question_groups_path(@survey)
        end

        def edit
          @question_group = @survey.question_groups.find(params[:id])
        end

        def update
          @question_group = @survey.question_groups.find(params[:id])
          if @question_group.update_attributes question_group_params
            flash[:notice] = t('actions.updated', ressource: @question_group.title)
          else
            flash[:error] = t 'actions.error'
            add_breadcrumb @question_group.name_was
          end
          respond_with @question_group, location: admin_survey_question_groups_path(@survey)
        end

        def destroy
          @question_group = @survey.question_groups.find(params[:id])
          flash[:notice] = t('actions.deleted', ressource: @question_group.title) if @question_group.destroy
          respond_with @question_group, location: admin_survey_question_groups_path(@survey)
        end

        private

        def load_survey
          @survey = Helena::Survey.find params['survey_id']
        end

        def add_breadcrumps
          add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
          add_breadcrumb @survey.name, admin_survey_question_groups_path(@survey)
        end

        def question_group_params
          params.require(:question_group).permit(:title, :position)
        end
      end
    end
  end
end
