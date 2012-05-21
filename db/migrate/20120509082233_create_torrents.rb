class CreateTorrents < ActiveRecord::Migration
  def change
    create_table :torrents do |t|
      t.string :name
      t.string :info_hash
      t.integer :category_id

      t.timestamps
    end
    
    add_index :torrents, :info_hash, :unique => true
    add_index :torrents, :category_id
  end
end
