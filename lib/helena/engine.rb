module Helena
  class Engine < ::Rails::Engine
    isolate_namespace Helena
    config.i18n.load_path += Dir[config.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Thanks to https://github.com/thoughtbot/factory_girl_rails/pull/42
    initializer "helena.factories", :after => "factory_girl.set_factory_paths" do
      FactoryGirl.definition_file_paths << File.expand_path('../../../spec/factories', __FILE__) if defined?(FactoryGirl)
    end
  end
end
