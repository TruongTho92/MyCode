class ChangeEmailsToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :email, :email
  end
end
