class AddUsersIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :name
    add_index :users, :country
    add_index :users, :score
    add_index :users, [:country, :score]
  end
end
