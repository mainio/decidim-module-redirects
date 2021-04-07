# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/redirects/version"

Gem::Specification.new do |spec|
  spec.name = "decidim-redirects"
  spec.version = Decidim::Redirects::VERSION
  spec.required_ruby_version = ">= 2.7"
  spec.authors = ["Antti Hukkanen"]
  spec.email = ["antti.hukkanen@mainiotech.fi"]

  spec.summary = "Provides redirection controls for a Decidim instance."
  spec.description = "Adds possibility to add and control redirections for Decidim."
  spec.homepage = "https://github.com/mainio/decidim-module-redirects"
  spec.license = "AGPL-3.0"

  spec.files = Dir[
    "{app,config,db,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "Rakefile",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "decidim-core", Decidim::Redirects::DECIDIM_VERSION

  spec.add_development_dependency "decidim-dev", Decidim::Redirects::DECIDIM_VERSION
end
