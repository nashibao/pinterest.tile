
class ViewModel
    constructor: (num)->
        @contents = ({name: i, height: 20+Math.random()*100} for i in [1..num])

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