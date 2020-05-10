# frozen_string_literal: true

module Decidim
  module Redirects
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action unless user
          return permission_action unless permission_action.scope == :admin

          unless user.admin?
            disallow!
            return permission_action
          end

          if read_admin_dashboard_action?
            allow!
            return permission_action
          end

          allowed_redirection_action?

          permission_action
        end

        private

        def redirection
          @redirection ||= context.fetch(:redirection, nil)
        end

        def allowed_redirection_action?
          return unless permission_action.subject == :redirection

          case permission_action.action
          when :create, :read
            allow!
          when :update, :destroy, :import, :export
            toggle_allow(redirection.present?)
          end
        end

        def read_admin_dashboard_action?
          permission_action.action == :read &&
            permission_action.subject == :admin_dashboard
        end
      end
    end
  end
end
