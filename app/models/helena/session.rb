module Helena
  class Session
    include Helena::Concerns::ApplicationModel

    field :token, type: String
    field :view_token, type: String
    field :completed, type: Boolean, default: false

    belongs_to :survey, inverse_of: :sessions
    belongs_to :version, inverse_of: :sessions

    embeds_many :answers, inverse_of: :session, class_name: 'Helena::Answer'

    validates :token, :view_token, uniqueness: true

    before_create :reset_tokens

    def reset_tokens
      # NOTE: there are (2*26+10)^k tokens available
      # To not run into performance issues we could pregenerate unique tokens in the future
      self.token = generate_token(5) until unique_token_for?
      self.view_token = generate_token(25) until unique_token_for?(:view_token)
    end

    def self.to_csv
      # TODO: Protect reserved fields in session as code i.e "updated_at"
      CSV.generate do |csv|
        csv << fields.keys + answer_codes
        all.each do |session|
          csv << session.attributes.values_at(*fields.keys) + answer_values_in(session)
        end
      end
    end

    private

    def self.answer_values_in(session)
      answers = []
      answer_codes.each do |code|
        answers << session.answers.where(code: code).first.try(&:value)
      end
      answers
    end

    def self.answer_codes
      answer_codes = []
      all.each do |session|
        answer_codes += session.answers.map(&:code) - answer_codes
      end
      answer_codes
    end

    def generate_token(size)
      SecureRandom.base64(size).delete('/+=')[0, size]
    end

    def unique_token_for?(field = :token)
      self.class.where(field => send(field)).blank? && send(field).present?
    end

    def self.available_codes_for(survey)
      Session.where(survey: survey).map do |session|
        session.answers.map(&:code)
      end.flatten.uniq
    end
  end
end
