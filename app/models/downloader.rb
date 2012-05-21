class Downloader < ActiveRecord::Base
  attr_accessible :user_id
  
  belongs_to :torrent
  belongs_to :user
end
