include FactoryGirl::Syntax::Methods

# TODO: Codes smells because we have to assign the factory path here
FactoryGirl.definition_file_paths += ['spec/factories']
FactoryGirl.find_definitions

progressbar = ProgressBar.create starting_at: 20, total: nil

DatabaseCleaner.strategy = :truncation && DatabaseCleaner.clean

5.times do
  create :survey
  progressbar.increment
end
