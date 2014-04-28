module Helena
  class SessionsController < ApplicationController
    respond_to :html

    before_filter :load_survey
    before_filter :load_session, only: [:edit, :update]

    def edit
    end

    private

    def load_survey
      @survey = Helena::Survey.find params[:survey_id]
    end

    def load_session
      @session = @survey.sessions.find params[:id]
      @version = @survey.versions.find @session.version_id
      @question_group = load_question_group
      @questions = @question_group.questions.asc(:position)
      @answers = answers_for(@session)
    end

    def load_question_group
      if params[:question_group]
        @version.question_groups.find params[:question_group]
      else
        @version.question_groups.asc(:position).first
      end
    end

    def answers_for(session)
      Hash[session.answers.map { |answer| [answer.code, answer.value] }]
    end
  end
end
