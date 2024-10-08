# frozen_string_literal: true

class CreateDecidimRedirectsRedirections < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_redirects_redirections do |t|
      t.references :decidim_organization, null: false, foreign_key: true
      t.integer :priority, null: false, default: 0
      t.string :path, null: false
      t.jsonb :parameters
      t.text :target, null: false
      t.boolean :external, null: false, default: false
    end

    add_index :decidim_redirects_redirections, :priority
    add_index :decidim_redirects_redirections, :path
  end
end
