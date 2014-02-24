require_dependency 'helena/application_controller'

module Helena
  module Admin
    module Surveys
      class QuestionGroupsController < Admin::ApplicationController
        respond_to :html

        before_filter :load_survey, :add_breadcrumps
        before_filter :sort, only: [:move_up, :move_down, :create]

        def index
          @question_groups = @survey.question_groups
        end

        def new
          add_breadcrumb t('.new')
          @question_group = @survey.question_groups.new survey: @survey
        end

        def create
          add_breadcrumb t('.new')

          @question_group = @survey.question_groups.new question_group_params
          @question_group.group_order = maximum_group_order + 1

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

        def move_up
          @question_group = @survey.question_groups.find(params[:id])

          if @question_group.group_order > 1
            previous_position = @question_group.group_order - 1
            previous_question_group = @survey.question_groups.find_by group_order: previous_position
            previous_question_group.update_attribute :group_order, @question_group.group_order
            @question_group.update_attribute :group_order, previous_position

            flash[:notice] = t('actions.updated', ressource: @question_group.title)
          end

          respond_with @survey, location: admin_survey_question_groups_path(@survey)
        end

        def move_down
          @question_group = @survey.question_groups.find(params[:id])

          if @question_group.group_order < maximum_group_order
            next_position =  @question_group.group_order + 1
            next_question_group = @survey.question_groups.find_by group_order: next_position
            next_question_group.update_attribute :group_order, @question_group.group_order
            @question_group.update_attribute :group_order, next_position

            flash[:notice] = t('actions.updated', ressource: @question_group.title)
          end

          respond_with @survey, location: admin_survey_question_groups_path(@survey)
        end

        def maximum_group_order
          @survey.question_groups.maximum(:group_order) || 0
        end

        private

        def sort
          @survey.question_groups.each_with_index do | question_group, index|
            question_group.update_attribute(:group_order, index + 1)
          end
        end

        def load_survey
          @survey = Helena::Survey.find params['survey_id']
        end

        def add_breadcrumps
          add_breadcrumb Helena::Survey.model_name.human(count: 2), :admin_surveys_path
          add_breadcrumb @survey.name, admin_survey_question_groups_path(@survey)
        end

        def question_group_params
          params.require(:question_group).permit(:title)
        end
      end
    end
  end
end
