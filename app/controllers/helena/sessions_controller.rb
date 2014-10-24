module Helena
  class SessionsController < ApplicationController
    respond_to :html

    before_filter :load_session, only: [:edit, :update]

    def show
      @session = Helena::Session.find_by view_token: params[:token]
      @survey = @session.survey
      @version = @survey.versions.find @session.version_id
      @question_group = question_group

      respond_to do |format|
        format.html { render html: session_report }
        format.json { render json: @session }
      end
    end

    def edit
      @questions = question_group_questions
      @answers = session_answers
      @errors = {}
    end

    def update
      @answers = update_answers
      @errors = answer_errors

      if @question_group.last? && @errors.blank?
        @session.update_attribute :completed, true
        render 'end_message'
      else
        @question_group = @question_group.next_item if @errors.blank?
        @questions = question_group_questions
        render 'edit'
      end
    end

    private

    def load_session
      @session = Helena::Session.find_by token: params[:token]
      @survey = @session.survey
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
      return unless params[:session]
      params.require(:session).permit(answers: @question_group.question_codes, question_types: @question_group.question_codes)
    end

    def question_group_questions
      @question_group.questions.asc(:position)
    end

    def update_answers
      @question_group.question_codes.each do |question_code|
        @session.answers.where(code: question_code).delete

        value = session_params[:answers][question_code] if session_params

        next if value.blank?

        answer = Helena::Answer.build_generic(question_code, value, request.remote_ip)
        @session.answers << answer
      end
      session_answers
    end

    def answer_errors
      errors = {}
      @question_group.questions.where(required: true).each do |question|
        question.validate_answers_in(session_answers).each do |question_code, error_message|
          errors[question_code] = t("errors.messages.#{error_message}")
        end
      end
      errors
    end

    private

    def session_report
      Slim::Template.new { @version.session_report }.render.html_safe if @version.session_report
    end
  end
end
