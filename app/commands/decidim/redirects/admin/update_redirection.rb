# frozen_string_literal: true

module Decidim
  module Redirects
    module Admin
      # This command is executed when the user changes a redirection from the
      # admin panel.
      class UpdateRedirection < Rectify::Command
        # Initializes an UpdateRedirection Command.
        #
        # form        - The form from which to get the data.
        # redirection - The current instance of the redirection to be updated.
        def initialize(form, redirection)
          @form = form
          @redirection = redirection
        end

        # Updates the record if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            update_redirection!
          end

          broadcast(:ok, redirection)
        end

        private

        attr_reader :form, :redirection

        def update_redirection!
          redirection.update!(
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
