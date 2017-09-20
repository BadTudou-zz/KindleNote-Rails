class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :title
      t.string :author
      t.string :cover_url
      t.numeric :rating

      t.timestamps
    end
  end
end
