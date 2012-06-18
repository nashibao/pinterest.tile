
class ViewModel
    constructor: (num)->
        @contents = (i for i in [1..num])

vm = new ViewModel(50)

tile = new Pinterest.Tile({container_dom: "#container_dom", tile_width: 320, tile_top: 100, img_dom_height: 195, allcalc:true, inner_dom_func: ()=>
            return $('div', $('#container_dom'))
        })

$(document).ready ()=>
    ko.applyBindings(vm)
    tile.start()