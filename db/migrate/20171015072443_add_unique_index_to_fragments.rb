class AddUniqueIndexToFragments < ActiveRecord::Migration[5.1]
  def change
    add_index :fragments, [:user_id, :note_id, :content], unique: true
  end
end
