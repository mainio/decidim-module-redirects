# frozen_string_literal: true

require "spec_helper"

describe "Redirect" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  context "when there is redirection with parameters" do
    let!(:redirection) { create(:redirection, path:, target:, parameters:, external:, organization:) }
    let(:path) { "/account" }
    let(:target) { "/pages/terms-of-service" }
    let(:external) { false }
    let(:parameters) { { foo: "bar" } }

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
