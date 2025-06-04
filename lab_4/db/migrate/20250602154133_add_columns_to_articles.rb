class AddColumnsToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :title, :string
    add_column :articles, :reports_count, :integer, default: 0
    add_column :articles, :archived, :boolean, default: false
    add_column :articles, :image, :string
  end
end
