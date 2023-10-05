class CreateLeaders < ActiveRecord::Migration[7.0]
  def change
    create_table :leaders do |t|
      t.belongs_to :user
      t.string :name
      t.string :country
      t.integer :score

      t.timestamps
    end
  end
end
