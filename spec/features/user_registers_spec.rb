require 'spec_helper'

feature "User registers", { js: true, vcr: true } do
  background do
    visit register_path
  end

  scenario "with valid personal info and valid card" do
    fill_in_valid_user_info
    fill_in_credit_card("4242424242424242")
    click_button "Sign Up"
    expect(page).to have_content "Thank you for your registration."
  end

  scenario "with valid personal info and invalid card" do
    fill_in_valid_user_info
    fill_in_credit_card("123")
    click_button "Sign Up"
    expect(page).to have_content "This card number looks invalid."
  end
  
  scenario "with valid personal info and declined card" do
    fill_in_valid_user_info
    fill_in_credit_card("4000000000000002")
    click_button "Sign Up"
    expect(page).to have_content "Your card was declined."
  end

  scenario "with invalid personal info and valid card" do
    fill_in_invalid_user_info
    fill_in_credit_card("4242424242424242")
    click_button "Sign Up"
    expect(page).to have_content "Invalid user information. Please check the errors below."
  end

  scenario "with invalid personal info and invalid card" do
    fill_in_invalid_user_info
    fill_in_credit_card("123")
    click_button "Sign Up"
    expect(page).to have_content "This card number looks invalid."
  end

  scenario "with invalid personal info and declined card" do
    fill_in_invalid_user_info
    fill_in_credit_card("4000000000000002")
    click_button "Sign Up"
    expect(page).to have_content "Invalid user information. Please check the errors below."
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "alice@example.com"
    fill_in "Password", with: "some_pw"
    fill_in "Full name", with: "Alice Chan"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "alice@example.com"
    fill_in "Full name", with: "Alice Chan"
  end
end
