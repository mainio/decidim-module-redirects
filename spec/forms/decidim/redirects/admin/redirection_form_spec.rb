# frozen_string_literal: true

require "spec_helper"

describe Decidim::Redirects::Admin::RedirectionForm do
  subject { described_class.from_params(params, current_organization: organization) }

  let(:organization) { create(:organization) }
  let(:params) { { redirection: } }
  let(:redirection) { { priority:, path:, parameters:, external:, target: } }
  let(:priority) { 6 }
  let(:path) { "/pages/terms-and-conditions" }
  let(:parameters) { "" }
  let(:external) { "0" }
  let(:target) { "/search" }

  context "when everything is OK" do
    it { is_expected.to be_valid }
  end

  context "when path is invalid" do
    let(:path) { Faker::Hacker.verb }

    it { is_expected.not_to be_valid }
  end

  context "when target is invalid" do
    let(:target) { Faker::Hacker.adjective }

    it { is_expected.not_to be_valid }
  end

  context "when target is external" do
    let(:external) { "1" }
    let(:target) { "https://www.mainiotech.fi" }

    it { is_expected.to be_valid }
  end

  context "when target is external but external isnt set" do
    let(:target) { Faker::Internet.url }

    it { is_expected.not_to be_valid }
  end

  context "when from model" do
    subject { described_class.from_model(redirection) }

    context "when everything is OK" do
      let(:redirection) { create(:redirection, organization:) }

      it { is_expected.to be_valid }
    end

    context "when parameters are hash" do
      let(:redirection) { create(:redirection, parameters:, organization:) }
      let(:parameters) { { "foo" => "bar", omg: "lol" } }

      it { is_expected.to be_valid }
    end

    context "when parameters are invalid" do
      let(:redirection) { create(:redirection, parameters: "test", organization:) }

      it { is_expected.not_to be_valid }
    end
  end
end
