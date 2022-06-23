class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text     :content
      t.bigint :user_id
      t.bigint :micropost_id
    end
    add_foreign_key :comments, :users
    add_foreign_key :comments, :microposts
  end
end
