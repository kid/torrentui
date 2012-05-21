class CreateDownloaders < ActiveRecord::Migration
  def change
    create_table :downloaders do |t|
      t.integer :user_id
      t.integer :torrent_id

      t.timestamps
    end
  end
end
