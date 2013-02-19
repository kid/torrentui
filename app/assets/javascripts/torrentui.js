var Torrentui = new Backbone.Marionette.Application({});

var Torrent = Backbone.Model.extend({});
var Torrents = Backbone.Collection.extend({});

var TorrentView = Backbone.Marionette.ItemView.extend({
	template: '#torrentView'
});

var TorrentsView = Backbone.Marionette.CompositeView.extend({
	itemView: TorrentView,
	itemViewContainer: 'tbody',
	template: '#torrentsView',
	tagName: 'tr',
});

Torrentui.addRegions({
	mainContainer: '#mainContainer'
})

Torrentui.addInitializer(function() {
	Torrentui.torrents = new Torrents();
	Torrentui.mainContainer.show(new TorrentsView({ collection: Torrentui.torrents }));
});

$(document).ready(function(){
  Torrentui.start();
});
