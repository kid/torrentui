class DownloadedFilesController < ApplicationController
  respond_to :json, :html

  def index
    @files = torrent.downloaded_files
    respond_with @files
  end
  
  def download
    @download = DownloadedFile.find(params[:id])
    path = File.join(AppSettings.transmission_download_dir, @download.path)
    
    file_begin = 0
    file_size = @download.length
    file_end = file_size - 1

    if !request.headers["Range"]
      status_code = "200 OK"
    else
      status_code = "206 Partial Content"
      match = request.headers['range'].match(/bytes=(\d+)-(\d*)/)
      if match
        file_begin = match[1]
        file_end = match[1] if match[2] && !match[2].empty?
      end
      response.header["Content-Range"] = "bytes " + file_begin.to_s + "-" + file_end.to_s + "/" + file_size.to_s
    end
    response.header["Content-Length"] = (file_end.to_i - file_begin.to_i + 1).to_s

    response.header["Cache-Control"] = "public, must-revalidate, max-age=0"
    response.header["Pragma"] = "no-cache"
    response.header["Accept-Ranges"]=  "bytes"
    response.header["Content-Transfer-Encoding"] = "binary"
    
    send_file(path, :status => status_code, :disposition => "inline", :stream =>  'true')
  end

  private
  def torrent
    @torrent ||= Torrent.find(params[:torrent_id])
  end
end
