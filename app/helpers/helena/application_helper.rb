module Helena
  module ApplicationHelper
    def requeired_note
      content_tag(:span, t('helena.shared.required_indicator'), aria: { hidden: true }) +
        content_tag(:span, t('helena.shared.sr_required_indicator'), class: 'sr-only')
    end

    def question_label(question, options = {})
      content_tag((options[:dummy] ? :span : :label), class: :label, for: "question_#{question.code}") do
        raw(question.question_text) + (requeired_note if question.required?)
      end
    end

    # Allows to set the header title within the text
    # i.e `h1 = title 'This will be also shown in the title tag'`
    # Do not forgot to set `content_for(:title)` within the title tag in the head.
    def title(page_title)
      content_for(:title, page_title)
      page_title
    end
  end
end
