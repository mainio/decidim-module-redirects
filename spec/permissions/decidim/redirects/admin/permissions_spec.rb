# frozen_string_literal: true

require "spec_helper"

describe Decidim::Redirects::Admin::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:organization) { create(:organization) }
  let(:context) { { redirection: create(:redirection, organization:) } }
  let(:permission_action) { Decidim::PermissionAction.new(**action) }

  context "when user is admin" do
    let(:user) { create(:user, :confirmed, :admin, organization:) }

    describe "read" do
      let(:action) do
        { scope: :admin, action: :read, subject: :redirection }
      end

      it { is_expected.to be true }
    end

    describe "read admin dashboard" do
      let(:action) do
        { scope: :admin, action: :read, subject: :admin_dashboard }
      end

      it { is_expected.to be true }
    end

    describe "create" do
      let(:action) do
        { scope: :admin, action: :create, subject: :redirection }
      end

      it { is_expected.to be true }
    end

    describe "update" do
      let(:action) do
        { scope: :admin, action: :update, subject: :redirection }
      end

      it { is_expected.to be true }
    end

    describe "destroy" do
      let(:action) do
        { scope: :admin, action: :destroy, subject: :redirection }
      end

      it { is_expected.to be true }
    end
  end

  context "when user is not admin" do
    let(:user) { create(:user, :confirmed, organization:) }

    describe "read" do
      let(:action) do
        { scope: :admin, action: :read, subject: :redirection }
      end

      it { is_expected.to be false }
    end

    describe "read admin dashboard" do
      let(:action) do
        { scope: :admin, action: :read, subject: :admin_dashboard }
      end

      it { is_expected.to be false }
    end

    describe "create" do
      let(:action) do
        { scope: :admin, action: :create, subject: :redirection }
      end

      it { is_expected.to be false }
    end

    describe "update" do
      let(:action) do
        { scope: :admin, action: :update, subject: :redirection }
      end

      it { is_expected.to be false }
    end

    describe "destroy" do
      let(:action) do
        { scope: :admin, action: :destroy, subject: :redirection }
      end

      it { is_expected.to be false }
    end
  end
end
