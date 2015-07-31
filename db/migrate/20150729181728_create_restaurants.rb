class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :image
      t.string :rating
      t.string :ride_estimate
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
