class CreateFragments < ActiveRecord::Migration[5.1]
  def change
    create_table :fragments do |t|
      t.integer :note_id
      t.integer :user_id
      t.string :fragment_type
      t.text :content
      t.string :datetime

      t.timestamps
    end
  end
end
