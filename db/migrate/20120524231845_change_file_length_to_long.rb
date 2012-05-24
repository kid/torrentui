class ChangeFileLengthToLong < ActiveRecord::Migration
  def change
    change_column :downloaded_files, :length, :decimal, :null => false
  end
end
