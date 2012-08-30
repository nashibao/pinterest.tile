
class ViewModel
    constructor: (num)->
        @contents = ko.observableArray(({name: i, height: 20+Math.random()*20} for i in [1..num]))
    load_more: ()->
        for i in [0..10]
            @contents.push({name: 'added', height: 20+Math.random()*100})
        tile.update()


vm = new ViewModel(500)

tile = new Pinterest.Tile {
    container: "#container_dom"
    , tile_width: 200
    , get_tiles_handler: ()=>
            return $('div', $('#container_dom'))
    }

$(document).ready ()=>
    ko.applyBindings(vm)
    tile.start()