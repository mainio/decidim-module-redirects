# frozen_string_literal: true

# Keep this in the lib folder instead of the app folder to avoid the following
# type of errors when classes are reloaded:
#   A copy of Decidim::Redirects::RedirectionMiddleware has been removed from
#   the module tree but is still active!
module Decidim
  module Redirects
    class RedirectionMiddleware
      # Initializes the Rack Middleware.
      #
      # app - The Rack application
      def initialize(app)
        @app = app
      end

      def call(env)
        organization = env["decidim.current_organization"]
        return @app.call(env) unless organization

        req = Rack::Request.new(env)
        redirects = (
          OrganizationRedirections.new(organization) |
          PathRedirections.new(req.path)
        )

        return @app.call(env) if redirects.count < 1

        # Find the first redirect that has no parameters defined or matches all
        # its parameter conditions with the values in the current request.
        redirect = redirects.find do |r|
          r.parameters.nil? || r.parameters.all? do |k, v|
            req.params[k] == v
          end
        end

        return @app.call(env) unless redirect

        location = redirect.target
        query = Rack::Utils.build_query(req.params)
        query = "?#{query}" unless query.empty?
        unless redirect.external?
          scheme = req.ssl? ? "https" : "http"
          host = organization.host
          host = "#{host}:#{req.port}" unless [80, 443].include?(req.port)
          location = "#{scheme}://#{host}#{location}#{query}"
        end

        [
          301,
          {
            "Location" => location,
            "Content-Type" => "text/html",
            "Content-Length" => "0"
          },
          []
        ]
      end
    end
  end
end
