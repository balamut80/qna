require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

	given(:user) { create(:user) }
	given!(:question) { create :question, user: user }

	background do
		sign_in(user)
		visit '/questions'
		click_on 'Ask question'
	end

	scenario 'User adds 2 files when asks question', js: true do
		fill_in 'Title', with: question.title
		fill_in 'Text', with: question.body

		click_on 'Add file'
		file_inputs = page.all('input[type="file"]')
		file_inputs[0].set "#{Rails.root}/spec/spec_helper.rb"
		file_inputs[1].set "#{Rails.root}/spec/rails_helper.rb"
		click_on 'Create'

		expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
		expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
	end
end