class AddOpenIdToAccessTokens < ActiveRecord::Migration[5.1]
  def change
    add_column :access_tokens, :openid, :string
  end
end
