# frozen_string_literal: true

module Decidim
  module Redirects
    # This is the engine that runs on the public interface of `decidim-plans`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Redirects::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :redirections, except: [:show]

        root to: "redirections#index"
      end

      initializer "decidim_redirects.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::Redirects::AdminEngine, at: "/admin/redirects", as: "decidim_admin_redirects"
        end
      end

      initializer "decidim_redirects.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item(
            I18n.t("menu.redirects", scope: "decidim.redirects"),
            decidim_admin_redirects.redirections_path,
            icon_name: "action-redo",
            position: 4.1,
            active: :inclusive,
            if: allowed_to?(:update, :organization, organization: current_organization)
          )
        end
      end
    end
  end
end
