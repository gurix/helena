module Helena
  class Engine < ::Rails::Engine
    isolate_namespace Helena
    config.i18n.load_path += Dir[config.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end
