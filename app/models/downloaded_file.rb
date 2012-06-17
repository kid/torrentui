class DownloadedFile < ActiveRecord::Base
  attr_accessible :length, :path
  
  belongs_to :torrent
  
  validates_presence_of :path
  
  def to_param
    "#{id}/#{file_name}"
  end
  
  def file_name
    File.split(path).last
  end
  
  def absolute_path
    File.expand_path File.join(AppSettings.transmission_download_dir, self.path)
  end
  
  def extract
  	
  end
end
