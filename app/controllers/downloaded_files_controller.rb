class DownloadedFilesController < ApplicationController
  respond_to :json, :html

  def index
    @files = torrent.downloaded_files
    respond_with @files
  end
  
  def download
    @file = DownloadedFile.find(params[:id])
    
    response.header["Accept-Ranges"]=  "bytes"
    response.header["Content-Transfer-Encoding"] = "binary"

    send_file(@file.absolute_path, :url_based_filename => true)
  end
  
  def extract
    @file = DownloadedFile.find(params[:id])
    if @file.is_archive?
      flash[:notice] = 'Extraction in progress...'
      @file.delay.extract 
    end
    
    redirect_to torrent_path(params[:torrent_id])
  end

  private
  def torrent
    @torrent ||= Torrent.find(params[:torrent_id])
  end
end