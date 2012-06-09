class CreateExtractedFiles < ActiveRecord::Migration
  def change
    create_table :extracted_files do |t|
      t.string :path
      t.decimal :length
      t.integer :torrent_id

      t.timestamps
    end
  end
end
