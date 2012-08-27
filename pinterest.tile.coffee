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
            , get_tiles: get_tiles
        } = options

        @container = if container then container else $(document)
        @tile_width = if tile_width then tile_width else 320
        @get_tiles = if get_tiles then get_tiles

        # @columns has height values and 
        # the value which tiles are in an column.
        # {height: integer, rows: []}
        @columns = []
        @heights = []

    start: ()=>
        @resize()
        # initialize
        $(window).resize () =>
            @resize()

    resize: (force_resizing=false)=>
        # container dom (to guarantee container point to jquery dom object.)
        container = $(@container)

        # index size of column
        col_num = Math.floor(container.width() / (@tile_width))

        # return when index size is unchanged
        only_width = false

        if !force_resizing and @columns.length != 0 and col_num == @columns.length
          only_width = true

        # padding
        padding = (container.width() - (col_num*@tile_width))/2


        # initialize parameters
        if only_width
            col_index = 0
            for column in @columns
                for dom in column.rows
                    dom.offset {
                        top: dom.offset().top
                        , left: padding + container.offset().left + @tile_width * col_index
                    }
                col_index += 1
        else
            @columns = []
            @heights = []
            for i in [0..col_num-1]
                @columns.push({height:0, rows:[], left:padding+container.offset().left+@tile_width*i})
                @heights.push(0)
            col_index = 0
            # max_height = 0

            for dom in @get_tiles()
                dom = $(dom)
                # TODO: min index
                min_height = _.min(@heights)
                col_index = _.indexOf(@heights, min_height)
                
                column = @columns[col_index]
                column.rows.push(dom)
                dom.offset {
                    top: container.offset().top+column.height
                    , left: column.left
                }
                column.height += dom.height()
                @heights[col_index] = column.height
                # col_index += 1
                # if col_index == col_num
                #     col_index = 0
