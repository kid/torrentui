require 'net/http'
require 'base64'
require 'json'

module Transmission
  RPC_PATH = 'transmission/rpc'
  
  class Client
    TORRENT_ARGS = %w(downloadDir hashString id isFinished name percentDone status totalSize error errorString rateDownload rateUpload)
    
    def initialize(host = '127.0.0.1', port = 9091, username = 'transmission', password = 'transmission')
      @header = {'Authorization' => 'Basic ' + Base64.encode64("#{username}:#{password}")}
      @uri = URI.parse "http://#{host}:#{port}/#{RPC_PATH}"
      new_connection
    end
    
    def new_connection
      @connection = Net::HTTP.start(@uri.host, @uri.port)
    end
    
    def torrent_get(info_hash)
      request 'torrent-get',  {:fields => TORRENT_ARGS}
    end
    
    def torrent_add_url(url)
      request 'torrent-add', {:filename => url}
    end
    
    def torrent_add_file(file_content)
      request 'torrent-add', {:metainfo => Base64.encode64(file_content)}
    end
    
    def request(method, args={})
      post_data = build_json method, args
      begin
        result = @connection.post2(@uri.path, post_data, @header)
      rescue
        new_connection
        return request method, args
      end
      case result
      when Net::HTTPSuccess
        JSON.parse(result.read_body)['arguments']
      when Net::HTTPConflict
        @header = @header.merge("x-transmission-session-id" => result.header["x-transmission-session-id"])
        request method, args
      when Net::HTTPBadResponse
        request method, args
      else
        raise Exception
      end
    end
    
    def build_json(method, attributes = {})
      if attributes.length == 0
        {'method' => method}.to_json
      else
        {'method' => method, 'arguments' => attributes}.to_json
      end
    end
  end
end
