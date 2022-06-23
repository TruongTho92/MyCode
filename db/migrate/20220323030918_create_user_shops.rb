class CreateUserShops < ActiveRecord::Migration[6.1]
  def change
    create_table :user_shops do |t|
      t.integer :user_id
      t.integer :shops_id

      t.timestamps
    end
  end
end
