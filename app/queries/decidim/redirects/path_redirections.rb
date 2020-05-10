# frozen_string_literal: true

module Decidim
  module Redirects
    # This query class filters redirections given a redirection path.
    class PathRedirections < Rectify::Query
      def initialize(path)
        @path = path
      end

      def query
        q = Decidim::Redirects::Redirection.where(path: @path)
        q.order("priority, path")
      end
    end
  end
end
