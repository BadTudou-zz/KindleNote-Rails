class AddOpenIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :openid, :string
  end
end
