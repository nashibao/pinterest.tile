
utils = this.utils

class ViewModel
    constructor: (num)->
        @contents = ko.observableArray([])

vm = new ViewModel(500)

tile = new Pinterest.Tile {
    container: "#container_dom"
    , tile_width: 200
    , get_tiles: ()=>
            return $('div[name="tile"]', $('#container_dom'))
    }

$(document).ready ()=>
    ko.applyBindings(vm)
    url = 'http://ws.audioscrobbler.com/2.0/?method=tag.getweeklyartistchart&tag=female&api_key=b25b959554ed76058ac220b7b2e0a026&format=json'
    utils.getJSON url, (data, dataType)=>
        vm.contents(data.weeklyartistchart.artist)
        tile.start()