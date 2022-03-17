class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :age
      t.integer :phone
      t.string :emails

      t.timestamps
    end
  end
end
