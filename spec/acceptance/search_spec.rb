require_relative 'acceptance_helper'

feature 'Search Sphinx' do

	given!(:users) { create_list :user, 2 }
	given!(:questions) { create_list :question, 2 }
	given!(:answers) { create_list :answer, 2 }
	given!(:comments) { create_list :comment, 2 }

	scenario 'User searches for any resource', js: true do
		ThinkingSphinx::Test.run do
			visit root_path

			fill_in 'Search', with: 'My Body'
			select 'All', from: 'filter'
			click_on 'Search'

			%w(Question Answer Comment).each do |resources|
				eval(resources).each do |res|
					expect(page).to have_content res.body
				end
			end

			users.each do |user|
				expect(page).to have_content user.email
			end
		end
	end

	scenario 'User searches for questions only', js: true do
		ThinkingSphinx::Test.run do
			visit root_path

			fill_in 'Search', with: 'My Body'
			select 'Question', from: 'filter'
			click_on 'Search'

			questions.each do |question|
				expect(page).to have_content question.title
				expect(page).to have_content question.body
			end
		end
	end

	scenario 'User searches for answers only', js: true do
		ThinkingSphinx::Test.run do
			visit root_path

			fill_in 'Search', with: 'My Body'
			select 'Answer', from: 'filter'
			click_on 'Search'

			answers.each do |answer|
				expect(page).to have_content answer.body
			end
		end
	end

	scenario 'User searches for comments only', js: true do
		ThinkingSphinx::Test.run do
			visit root_path

			fill_in 'Search', with: 'My Body'
			select 'Comment', from: 'filter'
			click_on 'Search'

			comments.each do |comment|
				expect(page).to have_content comment.body
			end
		end
	end

	scenario 'User searches for users only', js: true do
		ThinkingSphinx::Test.run do
			visit root_path

			fill_in 'Search', with: users.first.email
			select 'User', from: 'filter'
			click_on 'Search'

			expect(page).to have_content users.first.email
		end
	end
end