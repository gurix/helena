module Helena
  class SessionsController < ApplicationController
    respond_to :html

    before_filter :load_survey
    before_filter :load_session, only: [:edit, :update]

    def edit
      @questions = question_group_questions
      @answers = session_answers
    end

    def update
      @answers = update_answers

      if @question_group.last?
        @session.update_attribute :complete, true

        render 'end_message'
      else
        @question_group = @question_group.next_item
        @questions = question_group_questions

        render 'edit'
      end
    end

    private

    def load_survey
      @survey = Helena::Survey.find params[:survey_id]
    end

    def load_session
      @session = @survey.sessions.find params[:id]

      @version = @survey.versions.find @session.version_id
      @question_group = question_group
    end

    def question_group
      if params[:question_group]
        @version.question_groups.find params[:question_group]
      else
        @version.question_groups.asc(:position).first
      end
    end

    def session_answers
      Hash[@session.answers.map { |answer| [answer.code, answer.value] }]
    end

    def session_params
      params.require(:session).permit(answers: @question_group.question_codes, question_types: @question_group.question_codes)
    end

    def question_group_questions
      @question_group.questions.asc(:position)
    end

    def update_answers
      @question_group.question_codes.each do |question_code|
        answer = session_params[:answers][question_code]
        value = Helena::Answer.cast_value answer

        answer_class = value.is_a?(Fixnum) ? Helena::IntegerAnswer : Helena::StringAnswer
        if session_params[:question_types][question_code].present?
          answer_class = "Helena::#{session_params[:question_types][question_code]}.".classify
        end

        @session.answers.where(code: question_code).delete
        @session.answers << answer_class.new(code: question_code, value: value, ip_address: request.remote_ip) unless value.blank?
      end
      session_answers
    end
  end
end
