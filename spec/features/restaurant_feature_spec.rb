require 'rails_helper'

feature 'restaurants' do

	def create_user
	    visit('/')
	    click_link('Sign up')
	    fill_in('Email', with: 'test@example.com')
	    fill_in('Password', with: 'testtest')
	    fill_in('Password confirmation', with: 'testtest')
	    click_button('Sign up')
	end 

	context 'no restaurants have been added' do
		scenario 'should display a prompt to add a restaurant' do
			visit '/restaurants'
			expect(page).to have_content 'No restaurants yet'
			expect(page).not_to have_link 'Add a restaurant'
			create_user
			expect(page).to have_link 'Add a restaurant'			
		end
	end

	context 'restaurants have been added' do
	  before do
	    Restaurant.create(name: 'KFC')
	  end
	  scenario 'display restaurants' do
	    visit '/restaurants'
	    expect(page).to have_content('KFC')
	    expect(page).not_to have_content('No restaurants yet')
	  end
	end

	context 'creating restaurants' do
	  scenario 'prompts user to fill out a form, then displays the new restaurant' do
	  	create_user
	    visit '/restaurants'
	    click_link 'Add a restaurant'
	    fill_in 'Name', with: 'KFC'
	    click_button 'Create Restaurant'
	    expect(page).to have_content 'KFC'
	    expect(current_path).to eq '/restaurants'
	  end
	  context 'an invalid restaurant' do
	    it 'does not let you submit a name that is too short' do
	      create_user
	      visit '/restaurants'
	      click_link 'Add a restaurant'
	      fill_in 'Name', with: 'kf'
	      click_button 'Create Restaurant'
	      expect(page).not_to have_css 'h2', text: 'kf'
	      expect(page).to have_content 'error'
	    end
	  end
	end

	context 'viewing restaurants' do
		let!(:kfc){Restaurant.create(name:'KFC')}
		scenario 'lets a user view a restaurant' do
			visit '/restaurants'
			click_link 'KFC'
			expect(page).to have_content 'KFC'
			expect(current_path).to eq "/restaurants/#{kfc.id}"
		end
	end

	context 'editing restaurants' do
		before { Restaurant.create name: 'KFC' }
		scenario 'let a user edit a restaurant' do
			create_user
			visit '/restaurants'
			click_link 'Edit KFC'
			fill_in 'Name', with: 'Kentucky Fried Chicken'
			click_button 'Update Restaurant'
			expect(page).to have_content 'Kentucky Fried Chicken'
			expect(current_path).to eq '/restaurants'
		end

	end

	context 'deleting restaurants' do
		before {Restaurant.create name: 'KFC'}
		scenario 'removes a restaurant when a user clicks a delete link' do
			create_user
			visit '/restaurants'
			click_link 'Delete KFC'
			expect(page).not_to have_content 'KFC'
			expect(page).to have_content 'Restaurant deleted successfully'
		end
		# scenario 'also removes associated reviews and endorsements' do 
		# 	create_user
		# 	create_restaurant
			
		# end 
	end

	context 'uploading restaurant images' do 

		scenario 'adds an image to a restaurant profile' do 
			create_user
		    visit '/restaurants'
		    click_link 'Add a restaurant'
		    fill_in 'Name', with: 'KFC'
		    attach_file('restaurant_image', '../restaurants/spec/support/kfc.jpg')
		    click_button 'Create Restaurant'
		    expect(page).to have_css("img[src*='kfc.jpg']")
		end 
	end 

end
