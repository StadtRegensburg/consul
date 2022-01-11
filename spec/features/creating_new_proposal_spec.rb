# frozen_string_literal: true

require 'rails_helper'

feature 'user creates new proposal' do
  scenario 'successfully' do
    author = create(:user)
    login_as(author)
    byebug

    visit new_proposal_path(locale: :de)
    custom_fill_in_proposal

    click_button "Create proposal"

    expect(page).to have_content "Proposal created successfully."
  end
end
