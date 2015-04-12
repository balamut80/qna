require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

	given(:user) { create(:user) }
	given(:question) { create(:question) }
	given!(:answer) { create :answer, question: question, user: user }

	background do
		sign_in(user)
		visit question_path(question)
	end

	scenario 'User adds 2 files to answer', js: true do
		click_on 'Add file'
		file_inputs = page.all('input[type="file"]')
		fill_in 'Text', with: 'Answer text'

		file_inputs[0].set "#{Rails.root}/spec/spec_helper.rb"
		file_inputs[1].set "#{Rails.root}/spec/rails_helper.rb"

		click_on 'Create Answer'

		within '.answers' do
			expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
			expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
		end
	end
end