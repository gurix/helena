module Helena
  class Session < ActiveRecord::Base
    belongs_to :survey, inverse_of: :sessions
    belongs_to :version, inverse_of: :sessions

    before_create :reset_token

    def reset_token
      self.token = generate_token until unique_token?
    end

    private

    def generate_token
      SecureRandom.hex(5)
    end

    def unique_token?
      self.class.where(token: token).blank? && token.present?
    end
  end
end
