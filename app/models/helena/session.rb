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

    private

    def generate_token(size)
      SecureRandom.base64(size).delete('/+=')[0, size]
    end

    def unique_token_for?(field = :token)
      self.class.where(field => send(field)).blank? && send(field).present?
    end
  end
end
