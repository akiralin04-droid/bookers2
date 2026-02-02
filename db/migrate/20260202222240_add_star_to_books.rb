class AddStarToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :star, :string
  end
end
