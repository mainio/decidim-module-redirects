# frozen_string_literal: true

module Decidim
  module Redirects
    class Redirection < Decidim::Redirects::ApplicationRecord
      belongs_to :organization,
                 foreign_key: "decidim_organization_id",
                 class_name: "Decidim::Organization"
    end
  end
end
