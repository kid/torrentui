class Torrent < ActiveRecord::Base
  attr_accessible :info_hash, :name
end
