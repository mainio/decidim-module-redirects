# frozen_string_literal: true

module Decidim
  module Redirects
    module Admin
      class RedirectionsController < Admin::ApplicationController
        include Paginable

        helper_method :collection

        def index
          enforce_permission_to :read, :redirection
          @redirections = paginate(collection)
        end

        def new
          enforce_permission_to :create, :redirection

          @form = form(RedirectionForm).from_model(
            Redirection.new
          )
        end

        def edit
          enforce_permission_to(:update, :redirection, redirection:)
          @form = form(RedirectionForm).from_model(redirection)
        end

        def create
          enforce_permission_to :create, :redirection
          @form = form(RedirectionForm).from_params(
            params,
            current_organization:
          )

          CreateRedirection.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("redirections.create.success", scope: "decidim.redirects.admin")
              redirect_to redirections_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("redirections.create.error", scope: "decidim.redirects.admin")
              render action: "new"
            end
          end
        end

        def update
          enforce_permission_to(:update, :redirection, redirection:)
          @form = form(RedirectionForm).from_params(
            params,
            current_organization:
          )

          UpdateRedirection.call(@form, redirection) do
            on(:ok) do
              flash[:notice] = I18n.t("redirections.update.success", scope: "decidim.redirects.admin")
              redirect_to redirections_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("redirections.update.error", scope: "decidim.redirects.admin")
              render action: "edit"
            end
          end
        end

        def destroy
          enforce_permission_to(:destroy, :redirection, redirection:)
          redirection.destroy!

          flash[:notice] = I18n.t("redirections.destroy.success", scope: "decidim.redirects.admin")

          redirect_to redirections_path
        end

        private

        def redirections
          @redirections ||= OrganizationRedirections.new(current_organization).query
        end

        alias collection redirections

        def redirection
          @redirection ||= Decidim::Redirects::Redirection.find(params[:id])
        end
      end
    end
  end
end
