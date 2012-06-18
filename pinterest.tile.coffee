class Pinterest
class Pinterest.Tile
    constructor: (options)->
        {container_dom: container_dom, tile_width: tile_width, tile_top: tile_top, inner_dom_func: inner_dom_func, img_dom_height: img_dom_height, allcalc: allcalc} = options
        @container_dom = if container_dom then container_dom else $(document)
        @tile_width = if tile_width then tile_width else 320
        @tile_top = if tile_top then tile_top else 0
        @inner_dom_func = if inner_dom_func then inner_dom_func
        @img_dom_height = if img_dom_height then img_dom_height else 0
        @allcalc = if allcalc then allcalc else false
        @columns = []
        $(window).resize () =>
            @start()
    start: (force=false)=>
        parent = $(@container_dom)
        col_num = Math.floor(parent.width() / (@tile_width))
        if !@allcalc and !force and @columns.length != 0 and col_num == @columns.length
          return
        padding = 0
        if @allcalc
            padding = (parent.width() - (col_num*@tile_width))/2
        @columns = []
        for i in [0..col_num-1]
            @columns.push({height:@tile_top, rows:[]})
        col_index = 0
        max_height = 0
        for dom in @inner_dom_func()
            dom = $(dom)
            column = @columns[col_index]
            column.rows.push(dom)
            dom.offset({top:parent.offset().top+column.height, left:padding+parent.offset().left+@tile_width*col_index})
            column.height += dom.height()
            imgdom = $("img", dom)
            if imgdom and imgdom.height()==0
                column.height += @img_dom_height
            col_index += 1
            if col_index == col_num
                col_index = 0
            if max_height < column.height
                max_height = column.height
        parent.height(max_height+30)