require 'rails_helper'

feature 'endorsing reviews' do

	def create_user
	    visit('/')
	    click_link('Sign up')
	    fill_in('Email', with: 'test@example.com')
	    fill_in('Password', with: 'testtest')
	    fill_in('Password confirmation', with: 'testtest')
	    click_button('Sign up')
	end 

	def create_restaurant(name,image_path)
	    visit '/restaurants'
	    click_link 'Add a restaurant'
	    fill_in 'Name', with: name
	    attach_file('restaurant_image', File.absolute_path(image_path))
	    click_button 'Create Restaurant'
	end 

	def leave_review(thoughts,rating)
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: thoughts
		select rating, from: 'Rating'
		click_button 'Leave Review' 
	end

	before do
		create_user
		create_restaurant('KFC', '../restaurants/spec/support/kfc.jpg')
	    leave_review('It was an abomination', 3)
	end

	scenario 'a user can endorse a review, which increments the endorsement count', js: true do
		visit '/restaurants'
		click_link 'Endorse Review' 
		expect(page).to have_content('1 endorsement')
		click_link 'Endorse Review' 
		expect(page).to have_content('2 endorsements')
	end

end