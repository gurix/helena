module Helena
  class Session
    include Helena::Concerns::ApplicationModel

    field :token, type: String
    field :view_token, type: String
    field :completed, type: Boolean, default: false
    field :last_question_group_id, type: BSON::ObjectId

    belongs_to :survey, inverse_of: :sessions, class_name: 'Helena::Survey'
    belongs_to :version, inverse_of: :sessions, class_name: 'Helena::Version'

    embeds_many :answers, inverse_of: :session, class_name: 'Helena::Answer'

    validates :token, :view_token, uniqueness: true

    index created_at: 1
    index updated_at: 1

    before_create :reset_tokens

    def answers_as_yaml
      Hash[answers.map { |answer| [answer.code, answer.value] }.sort].to_yaml
    end

    def answers_as_yaml=(yaml)
      parsed_answers = YAML.safe_load yaml
      update_answers parsed_answers
    end

    def reset_tokens
      # NOTE: there are (2*26+10)^k tokens available
      # To not run into performance issues we could pregenerate unique tokens in the future
      self.token = generate_token(5) until unique_token_for?
      self.view_token = generate_token(25) until unique_token_for?(:view_token)
    end

    def as_json(options)
      session = super(options)
      session[:answer] = answers_as_hash
      session
    end

    def answers_as_hash
      Hash[*answers.map { |answer| [answer[:code], answer[:value]] }.flatten]
    end

    private

    def generate_token(size)
      SecureRandom.base64(size).delete('/+=')[0, size]
    end

    def unique_token_for?(field = :token)
      self.class.where(field => send(field)).blank? && send(field).present?
    end

    def update_answers(parsed_answers)
      answers.delete_all
      parsed_answers.each do |code, value|
        answers << Helena::Answer.build_generic(code, value, '')
      end
    end
  end
end
