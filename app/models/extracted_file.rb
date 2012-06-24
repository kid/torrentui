class ExtractedFile < ActiveRecord::Base
  attr_accessible :length, :path
  
  belongs_to :torrent
  
  validates_presence_of :path
  
  def file_name
    File.split(path).last
  end
  
  def absolute_path
    File.expand_path File.join(AppSettings.extract_files_destination, self.path)
  end
end
