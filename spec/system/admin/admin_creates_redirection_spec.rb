# frozen_string_literal: true

require "spec_helper"

describe "Admin creates redirection", type: :system do
  let(:organization) { create :organization }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }
  let(:priority) { rand(0..1337) }
  let(:path) { "/foo/bar" }
  let(:target) { ::Faker::Internet.url }
  let(:parameters) { rand(2) == 1 ? "some=thing&foo=bar" : "" }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit "/admin/redirects/redirections"
  end

  describe "redirects index" do
    let!(:redirection) { create(:redirection, organization: organization) }

    it "shows redirection" do
      visit current_path
      expect(page).to have_content("Redirections")
      expect(page).to have_content(redirection.path)
      expect(page).to have_content(redirection.target)
      expect(page).to have_content(redirection.priority)
    end
  end

  describe "create redirection" do
    before do
      click_link "New redirection", match: :first

      within "#redirection_priority" do
        fill_in with: priority
      end

      within "#redirection_path" do
        fill_in with: path
      end

      within "#redirection_parameters" do
        fill_in with: parameters
      end
    end

    it "creates new internal redirection" do
      within "#redirection_target" do
        fill_in with: "/pages/faq"
      end

      click_button "Create"
      expect(page).to have_content("Redirection successfully created")
    end

    it "creates new external redirection" do
      find(:css, "#redirection_external").set(true)

      within "#redirection_target" do
        fill_in with: ::Faker::Internet.url
      end

      click_button "Create"
      expect(page).to have_content("Redirection successfully created")
    end
  end

  describe "edit redirection" do
    let!(:redirection) { create(:redirection, organization: organization) }

    it "edits redirection" do
      visit current_path

      click_link redirection.path

      within "#redirection_priority" do
        fill_in with: 7777
      end

      within "#redirection_path" do
        fill_in with: path
      end

      within "#redirection_parameters" do
        fill_in with: "mainio=tech"
      end

      find(:css, "#redirection_external").set(false)

      within "#redirection_target" do
        fill_in with: "/mainio/tech"
      end

      click_button "Save"
      expect(page).to have_content("Redirection successfully updated")
      expect(page).not_to have_content(redirection.path)
      expect(page).not_to have_content(redirection.target)
      expect(page).to have_content("/mainio/tech")
      expect(page).to have_content("7777")
    end
  end
end
