module Helena
  class Participant < ActiveRecord::Base
    has_many :surveys, dependent: :destroy
  end
end
