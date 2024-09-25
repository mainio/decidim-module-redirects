# frozen_string_literal: true

require "spec_helper"

describe "Redirection" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:priority) { rand(0..1337) }
  let(:path) { "/foo/bar" }
  let(:target) { Faker::Internet.url }
  let(:parameters) { "some=thing&foo=bar" }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit "/admin/redirects/redirections"
  end

  describe "redirects index" do
    let!(:redirection) { create(:redirection, organization:) }

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
      click_on "New redirection", match: :first

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

      click_on "Create"
      expect(page).to have_content("Redirection successfully created")
    end

    it "creates new external redirection" do
      find_by_id("redirection_external").set(true)

      within "#redirection_target" do
        fill_in with: Faker::Internet.url
      end

      click_on "Create"
      expect(page).to have_content("Redirection successfully created")
    end
  end

  describe "edit redirection" do
    let!(:redirection) { create(:redirection, organization:) }

    it "edits redirection" do
      visit current_path

      click_on redirection.path

      within "#redirection_priority" do
        fill_in with: 7777
      end

      within "#redirection_path" do
        fill_in with: path
      end

      within "#redirection_parameters" do
        fill_in with: "mainio=tech"
      end

      find_by_id("redirection_external").set(false)

      within "#redirection_target" do
        fill_in with: "/mainio/tech"
      end

      click_on "Save"
      expect(page).to have_content("Redirection successfully updated")
      expect(page).to have_no_content(redirection.path)
      expect(page).to have_no_content(redirection.target)
      expect(page).to have_content("/mainio/tech")
      expect(page).to have_content("7777")
    end
  end
end
