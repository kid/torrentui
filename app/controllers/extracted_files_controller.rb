class ExtractedFilesController < ApplicationController
  respond_to :json, :html
  
  def download
    @file = ExtractedFile.find(params[:id])
    
    response.header["Accept-Ranges"]=  "bytes"
    response.header["Content-Transfer-Encoding"] = "binary"

    send_file(@file.absolute_path, :url_based_filename => true)
  end
end
