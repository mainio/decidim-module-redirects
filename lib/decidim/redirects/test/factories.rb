# frozen_string_literal: true

FactoryBot.define do
  factory :redirection, class: "Decidim::Redirects::Redirection" do
    priority { rand(1..100) }
    path { "/pages/terms-and-conditions" }
    parameters { nil }
    target { ::Faker::Internet.url }
    external { true }
  end
end
