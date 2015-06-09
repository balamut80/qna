require 'rails_helper'

RSpec.configure do |config|

	Capybara.javascript_driver = :webkit
	config.include AcceptanceMacros, type: :feature
	config.include OmniauthMacros, type: :feature

	config.use_transactional_fixtures = false

	config.before(:suite) do
		DatabaseCleaner.clean_with(:truncation)
		ThinkingSphinx::Test.init
		ThinkingSphinx::Test.start_with_autostop
	end

	config.before(:each) do
		DatabaseCleaner.strategy = :transaction
	end

	config.before(:each, js: true) do
		DatabaseCleaner.strategy = :truncation
		index
	end

	config.before(:each) do
		DatabaseCleaner.start
	end

	config.after(:each) do
		DatabaseCleaner.clean
  end

	config.include SphinxHelpers, type: :feature
end