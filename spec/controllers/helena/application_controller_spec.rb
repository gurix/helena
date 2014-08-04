require 'spec_helper'

describe Helena::ApplicationController do
  describe '.add_breadcrumb' do
    it 'names an empty element "Untitled"' do
      application_controller = Helena::ApplicationController.new

      application_controller.add_breadcrumb('')
      breadcrumbs = application_controller.add_breadcrumb(nil)

      expect(breadcrumbs.first.name).to eq 'Untitled'
      expect(breadcrumbs.last.name).to eq 'Untitled'
    end
  end
end
