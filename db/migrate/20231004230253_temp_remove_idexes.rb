class TempRemoveIdexes < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, columns: :name, name: 'index_users_on_name'
    remove_index :users, columns: :country, name: 'index_users_on_country'
    remove_index :users, columns: :score, name: 'index_users_on_score'
    remove_index :users, columns: [:country, :score], name: 'index_users_on_country_and_score'
  end
end
