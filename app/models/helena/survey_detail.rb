module Helena
  class SurveyDetail
    include Helena::Concerns::ApplicationModel

    field :title, type: String
    field :description, type: String

    embedded_in :version
  end
end
