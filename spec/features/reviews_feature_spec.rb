require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'KFC'}

  def leave_review(thoughts,rating)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review' 
  end

  scenario 'allows users to leave a review using a form' do
    leave_review("so so", '3')
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'removes reviews when a restaurant is removed' do 
    visit '/restaurants'
    leave_review("so so", '3')
    click_link 'Delete KFC'
    expect(page).not_to have_content 'so so'
  end 

  scenario 'displays an average rating for all reviews' do
    leave_review('So so', '3')
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★☆')
  end

  # context "showing time since creation" do

  #   before do
  #     Review.create(comments: "Hi", rating: 3, restaurant_id: kfc.id, created_at: (Time.now - 120))
  #   end

  #   it 'displays the time that has passed since the review was posted' do
  #     visit '/restaurants'
  #     expect(page.find('.time_since')).to have_content("2 minutes")
  #   end

  # end

end