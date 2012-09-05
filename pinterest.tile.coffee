class Pinterest
class Pinterest.Tile
    constructor: (options)->
        # options
        {
            # dom container
            container: container
            # tile width
            , tile_width: tile_width
            # return an array which store all tile doms
            , get_tiles_handler: get_tiles_handler
            # notify the timing when a tile is resized
            # ext:
            # update_tile_handler: (callback)=>
            #    $('img').load (evt)=>
            #       tile = $(evt.target).parent()
            #       callback tile
            , update_tile_handler: update_tile_handler
        } = options

        @container = if container then container else $(document)
        @tile_width = if tile_width then tile_width else 320
        @get_tiles_handler = if get_tiles_handler then get_tiles_handler else false
        @update_tile_handler = if update_tile_handler then update_tile_handler else false

        @columns = []
        @heights = []
        @container_width = 0

        @padding = 0
        @col_num = 0
        @max_height = 0

    start: ()=>
        @container = $(@container)
        @_resize()
        if @update_tile_handler
            @update_tile_handler (tile)=>
                @_resize(force_update_column_size=false, tile_for_update=tile)
        $(window).resize () =>
            @_resize()

    update: (tile=false)=>
        @_resize(force_update_column_size=false, tile_for_update=tile)

    _update_dom: (dom, column, col_index, row_index, update_left=false, update_top=false)=>
        nleft = if update_left then @padding + @container.offset().left + @tile_width * col_index else column.left
        ntop = if update_top then @container.offset().top+column.height else dom.offset().top
        dom.offset {top: ntop, left: nleft}
        if update_top
            column.height += dom.height()
            @heights[col_index] = column.height
            if @max_height < column.height
                @max_height = column.height
                @container.height(@max_height)

    _add_dom:(dom)=>
        dom = $(dom)
        col_index = _.indexOf(@heights, _.min(@heights))
        column = @columns[col_index]
        column.rows.push(dom)
        row_index = column.rows.length-1
        dom.data('puicolindex', col_index)
        dom.data('puirowindex', row_index)
        dom.data('puienabled', true)
        @_update_dom(dom, column, col_index, row_index, update_left=false, update_top=true)

    _resize: (force_update_column_size=false, tile_for_update=false)=>
        # index size of column
        @col_num = Math.floor(@container.width() / (@tile_width))
        
        # boolean whether moving tiles between columns
        should_update_column_size = true
        should_update_left = false

        if @container_width != @container.width()
            should_update_left = true
            @container_width = @container.width()

        if !force_update_column_size and @columns.length != 0 and @col_num == @columns.length
            should_update_column_size = false
        
        @padding = (@container.width() - (@col_num*@tile_width))/2

        # calcurate
        if should_update_column_size
            #initialize
            @columns = []
            @heights = []
            @max_height = 0
            for i in [0..@col_num-1]
                column = {height:0, rows:[], left:@padding+@container.offset().left+@tile_width*i, col_index: i}
                @columns.push(column)
                @heights.push(0)
            col_index = 0
            for dom in @get_tiles_handler()
                @_add_dom(dom)
        else
            if tile_for_update
                puienabled = tile_for_update.data('puienabled')
                if not puienabled
                    @_add_dom(tile_for_update)
                else
                    col_index = parseInt(tile_for_update.data('puicolindex'), 10)
                    row_index = parseInt(tile_for_update.data('puirowindex'), 10)
                    column = @columns[col_index]
                    if (column.rows.length - 1) <= row_index
                        return
                    column.height = 0
                    for i in [0..row_index]
                        dom = column.rows[i]
                        column.height += dom.height()
                    for i in [row_index+1..column.rows.length-1]
                        dom = column.rows[i]
                        @_update_dom(dom, column, col_index, row_index, update_left=false, update_top=true)
            # change for all columns
            else
                for dom in @get_tiles_handler()
                    dom = $(dom)
                    puienabled = dom.data('puienabled')
                    if not puienabled
                        utils.log puienabled
                        @_add_dom(dom)
                    else if should_update_left
                        col_index = parseInt(dom.data('puicolindex'), 10)
                        row_index = parseInt(dom.data('puirowindex'), 10)
                        column = @columns[col_index]
                        @_update_dom(dom, column, col_index, 0, update_left=true, update_top=false)
