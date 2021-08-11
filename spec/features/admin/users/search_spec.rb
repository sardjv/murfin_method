require 'rails_helper'

describe 'Admin searches for user', type: :feature, js: true do
  let!(:admin) { create :admin }

  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:email) { Faker::Internet.email }
  let(:similar_email) { "#{email.split('@').first}@#{Faker::Internet.domain_name}" }

  let!(:user1) { create :user, first_name: first_name, last_name: last_name, email: email }
  let!(:user2) { create :user, last_name: last_name }
  let!(:user3) { create :user, email: similar_email }

  before do
    log_in admin
    visit admin_users_path

    find_field(type: 'search').set(query)
    click_button 'Search'
  end

  describe 'find by first and last name, case insensitive' do
    let(:query) { "#{user3.first_name.downcase} #{user3.last_name}" }

    it 'finds matching users' do
      within '#users-list' do
        expect(page).not_to have_content user1.email
        expect(page).not_to have_content user2.email
        expect(page).to have_content user3.email
      end
    end
  end

  describe 'find by last and first name, case insensitive' do
    let(:query) { "#{user3.last_name.downcase} #{user3.first_name}" }

    it 'finds matching users' do
      within '#users-list' do
        expect(page).not_to have_content user1.email
        expect(page).not_to have_content user2.email
        expect(page).to have_content user3.email
      end
    end
  end

  describe 'find by last name' do
    let(:query) { last_name }

    it 'finds matching users' do
      within '#users-list' do
        expect(page).to have_content user1.email
        expect(page).to have_content user2.email
        expect(page).not_to have_content user3.email
      end
    end
  end

  describe 'find by username part of email' do
    let(:query) { email.split('@').first }

    it 'finds matching users' do
      within '#users-list' do
        expect(page).to have_content user1.email
        expect(page).not_to have_content user2.email
        expect(page).to have_content user3.email
      end
    end
  end

  describe 'find by EPR uuid' do
    let(:query) { user3.epr_uuid }

    it 'finds matching users' do
      within '#users-list' do
        expect(page).not_to have_content user1.email
        expect(page).not_to have_content user2.email
        expect(page).to have_content user3.email
      end
    end
  end
end
