# frozen_string_literal: true

module Decidim
  module Redirects
    # This query class filters all redirections in an organization.
    class OrganizationRedirections < Rectify::Query
      def initialize(organization)
        @organization = organization
      end

      def query
        q = Decidim::Redirects::Redirection.where(organization: @organization)
        q.order("priority, path")
      end

      def count
        query.count(:id)
      end
    end
  end
end
