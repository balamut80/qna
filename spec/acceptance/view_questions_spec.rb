require 'rails_helper'

feature 'View questions' do

	given(:questions) { Question.all  }

	scenario 'User views questions' do
		visit questions_path

		questions.each { |q| expect(page).to have_content q.title }
	end

end