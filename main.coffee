
class ViewModel
    constructor: (num)->
        @contents = (i for i in [1..num])

vm = new ViewModel(500)

tile = new Pinterest.Tile {
    container: "#container_dom"
    , tile_width: 200
    , get_tiles: ()=>
            return $('div', $('#container_dom'))
    }

$(document).ready ()=>
    ko.applyBindings(vm)
    tile.start()