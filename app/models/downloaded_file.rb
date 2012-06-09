class DownloadedFile < ActiveRecord::Base
  attr_accessible :length, :path
  
  belongs_to :torrent
  
  validates_presence_of :path
  
  def full_path
    File.expand_path File.join(AppSettings.transmission_download_dir, self.path)
  end
  
  def extract
  	
  end
end
