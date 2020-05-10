# frozen_string_literal: true

module Decidim
  module Redirects
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Redirects

      initializer "decidim_redirects.middleware" do |app|
        app.middleware.use ::Decidim::Redirects::RedirectionMiddleware
      end
    end
  end
end
