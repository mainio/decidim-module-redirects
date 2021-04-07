# frozen_string_literal: true

require "spec_helper"

describe Decidim::Redirects::Admin::RedirectionsController, type: :controller do
  routes { Decidim::Redirects::AdminEngine.routes }

  let(:user) { create(:user, :admin, :confirmed) }
  let(:params) { { "redirection": redirection } }
  let(:redirection) { { "priority": priority, "path": path, "parameters": parameters, "external": external, "target": target } }
  let(:priority) { rand(1..1000) }
  let(:path) { "/pages/terms-and-conditions" }
  let(:parameters) { "" }
  let(:external) { "0" }
  let(:target) { "/search" }

  before do
    request.env["decidim.current_organization"] = user.organization
    sign_in user
  end

  describe "POST create" do
    it "creates redirection" do
      post :create, params: params
      expect(Decidim::Redirects::Redirection.count).to eq(1)
    end

    context "when parameters are invalid" do
      let(:parameters) { "foo" }

      it "doesnt create redirection" do
        post :create, params: params
        expect(Decidim::Redirects::Redirection.count).to eq(0)
      end
    end
  end

  context "when there is redirection" do
    let!(:redirection) { create(:redirection, organization: user.organization) }

    describe "PATCH update" do
      let(:params) { { redirection: updated_redirection, id: redirection.id } }
      let(:updated_redirection) { { "priority": updated_priority, "path": updated_path, "parameters": updated_parameters, "external": updated_external, "target": updated_target } }
      let(:updated_priority) { rand(1..1000) }
      let(:updated_path) { "/updated/path" }
      let(:updated_parameters) { "very=nice&updated=are" }
      let(:updated_external) { "0" }
      let(:updated_target) { "/some/updated/target" }

      it "updates redirection" do
        patch :update, params: { id: redirection.id, redirection: updated_redirection }
        expect(Decidim::Redirects::Redirection.last.priority).to eq(updated_priority)
        expect(Decidim::Redirects::Redirection.last.path).to eq(updated_path)
        expect(Decidim::Redirects::Redirection.last.parameters).to eq("very" => "nice", "updated" => "are")
        expect(Decidim::Redirects::Redirection.last.external).to eq(false)
        expect(Decidim::Redirects::Redirection.last.target).to eq(updated_target)
      end

      context "when params are invalid" do
        let(:invalid_redirection) { { foo: "bar" } }

        it "doesnt update redirection" do
          patch :update, params: { id: redirection.id, redirection: invalid_redirection }

          expect(Decidim::Redirects::Redirection.last.path).to eq(redirection.path)
          expect(Decidim::Redirects::Redirection.last.parameters).to eq(redirection.parameters)
          expect(Decidim::Redirects::Redirection.last.external).to eq(redirection.external)
          expect(Decidim::Redirects::Redirection.last.target).to eq(redirection.target)
        end
      end
    end

    describe "DELETE destroy" do
      let(:params) { { id: redirection.id } }

      it "destroys redirection" do
        expect do
          delete :destroy, params: params
        end.to change { Decidim::Redirects::Redirection.count }.by(-1)
      end
    end
  end
end
