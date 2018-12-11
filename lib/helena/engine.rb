module Helena
  class Engine < ::Rails::Engine
    isolate_namespace Helena
    config.i18n.load_path += Dir[config.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Thanks to https://github.com/thoughtbot/factory_girl_rails/pull/42
    initializer 'helena.factories', after: 'factory_bot.set_factory_paths' do
      FactoryBot.definition_file_paths << File.expand_path('../../spec/factories/helena', __dir__) if defined?(FactoryBot)
    end

    # config.to_prepare do
    #   Dir.glob(Rails.root + 'app/decorators/**/*_decorator*.rb').each do |c|
    #     require_dependency c
    #   end
    # end
  end
end
