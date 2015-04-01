require_relative 'acceptance_helper'

feature 'View questions' do

	given!(:questions){ create_list(:question, 10) }

	scenario 'User views questions' do
		visit questions_path

		questions.each do |q|
			expect(page).to have_content q.title
		end
	end

end