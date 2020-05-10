# frozen_string_literal: true

module Decidim
  module Redirects
    module Admin
      # A command with all the business logic when creating a redirection.
      class CreateRedirection < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            @redirection = create_redirection!
          end

          if @redirection.persisted?
            broadcast(:ok, @redirection)
          else
            broadcast(:invalid)
          end
        end

        private

        attr_reader :form

        def create_redirection!
          Redirects::Redirection.create!(
            organization: form.current_organization,
            priority: form.priority,
            path: form.path,
            parameters: form.parameters_hash,
            target: form.target,
            external: form.external
          )
        end
      end
    end
  end
end
