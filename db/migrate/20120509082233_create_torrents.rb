class CreateTorrents < ActiveRecord::Migration
  def change
    create_table :torrents do |t|
      t.string :name
      t.string :info_hash
      t.string :magnet_link
      t.string :file_content

      t.timestamps
    end
  end
end
