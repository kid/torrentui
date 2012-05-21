class DownloadedFile < ActiveRecord::Base
  attr_accessible :length, :path
  
  belongs_to :torrent
  
  validates_presence_of :path
end
