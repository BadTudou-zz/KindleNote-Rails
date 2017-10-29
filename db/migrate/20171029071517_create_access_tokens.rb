class CreateAccessTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :access_tokens do |t|
      t.integer :user_id
      t.belongs_to :user, index: true
      t.text :name
      t.text :access_token
      t.text :scopes
      t.timestamp :expires
      t.boolean :revoked

      t.timestamps
    end
  end
end
