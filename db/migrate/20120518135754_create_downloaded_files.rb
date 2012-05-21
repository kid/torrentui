class CreateDownloadedFiles < ActiveRecord::Migration
  def change
    create_table :downloaded_files do |t|
      t.string :path
      t.integer :length
      t.integer :torrent_id

      t.timestamps
    end
    
    add_index :downloaded_files, :torrent_id
  end
end
