# frozen_string_literal: true

module Decidim
  module Redirects
    module Admin
      class RedirectionForm < Decidim::Form
        mimic :redirection

        attribute :priority, Integer, default: 0
        attribute :path, String
        attribute :parameters, String
        attribute :target, String
        attribute :external, Boolean

        validates :priority, presence: true
        validates :path, presence: true
        validates :target, presence: true
        validate :check_path_format, :check_target_format, :check_parameters_format

        def map_model(model)
          return unless model.parameters.is_a?(Hash)

          self.parameters = model.parameters.map { |k, v| "#{k}=#{v}" }.join("&")
        end

        def parameters_hash
          return nil if parameters.strip.empty?

          parameters.strip.sub(/^\?/, "").split("&").map do |param|
            kv = param.split("=")
            kv[1].empty? ? nil : kv
          end.compact.to_h
        end

        private

        def check_path_format
          return if path&.match? %r{\A(/[^\s]+)+\z}

          errors.add(:path, :invalid_format)
        end

        def check_parameters_format
          return if parameters.blank?
          return if parameters.match?(/^(\w+=\w+){1}(&\w+=\w+)*/)

          errors.add(:parameters, :invalid_format_parameters)
        end

        def check_target_format
          return check_target_format_external if external
          return if target&.match? %r{\A(/[^\s]+)+\z}

          errors.add(:target, :invalid_format_local)
        end

        def check_target_format_external
          return if target&.match? %r{\Ahttps?://[^\s/$.?#].[^\s]*\z}

          errors.add(:target, :invalid_format_external)
        end
      end
    end
  end
end
