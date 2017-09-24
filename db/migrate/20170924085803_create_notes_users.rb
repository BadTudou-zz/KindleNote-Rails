class CreateNotesUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :notes_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :note, index: true
      t.timestamps
    end
  end
end
