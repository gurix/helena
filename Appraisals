appraise 'rails-4.2' do
  gem 'rails', '4.2'
  gem 'mongoid-rspec', group: %i[development test]
  gemspec
end

appraise 'rails-5.0' do
  gem 'rails', '5.0'
  gem 'mongoid', '>= 6.0'
  gem 'mongoid-rspec', git: 'https://github.com/mongoid-rspec/mongoid-rspec.git', group: %i[development test]
  gemspec
end
