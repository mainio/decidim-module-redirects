# frozen_string_literal: true

require "spec_helper"

describe "User gets redirected", type: :system do
  let(:organization) { create :organization }
  let(:user) { create(:user, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  context "when there is redirection with parameters" do
    let!(:redirection) { create(:redirection, path: path, target: target, parameters: parameters, external: external, organization: organization) }
    let(:path) { "/account" }
    let(:target) { "/pages/terms-and-conditions" }
    let(:external) { false }
    let(:parameters) { { "foo": "bar" } }

    it "redirects because parameters are correct" do
      visit "#{path}?#{parameters.keys.first}=#{parameters.values.first}"
      expect(URI.parse(current_url).to_s).to include(target)
    end

    it "doesnt redirect without path parameters" do
      visit path
      expect(URI.parse(current_url).to_s).to include(path)
    end
  end
end
