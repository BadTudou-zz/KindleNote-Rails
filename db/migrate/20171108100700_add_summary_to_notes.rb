class AddSummaryToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :summary, :text
  end
end
