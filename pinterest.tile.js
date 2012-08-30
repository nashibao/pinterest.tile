// Generated by CoffeeScript 1.3.3
var Pinterest,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Pinterest = (function() {

  function Pinterest() {}

  return Pinterest;

})();

Pinterest.Tile = (function() {

  function Tile(options) {
    this._resize = __bind(this._resize, this);

    this._add_dom = __bind(this._add_dom, this);

    this._update_dom = __bind(this._update_dom, this);

    this.update = __bind(this.update, this);

    this.start = __bind(this.start, this);

    var container, get_tiles_handler, tile_width, update_tile_handler;
    container = options.container, tile_width = options.tile_width, get_tiles_handler = options.get_tiles_handler, update_tile_handler = options.update_tile_handler;
    this.container = container ? container : $(document);
    this.tile_width = tile_width ? tile_width : 320;
    this.get_tiles_handler = get_tiles_handler ? get_tiles_handler : false;
    this.update_tile_handler = update_tile_handler ? update_tile_handler : false;
    this.columns = [];
    this.heights = [];
    this.container_width = 0;
    this.padding = 0;
    this.col_num = 0;
    this.max_height = 0;
  }

  Tile.prototype.start = function() {
    var _this = this;
    this.container = $(this.container);
    this._resize();
    if (this.update_tile_handler) {
      this.update_tile_handler(function(tile) {
        var force_update_column_size, tile_for_update;
        return _this._resize(force_update_column_size = false, tile_for_update = tile);
      });
    }
    return $(window).resize(function() {
      return _this._resize();
    });
  };

  Tile.prototype.update = function(tile) {
    var force_update_column_size, tile_for_update;
    if (tile == null) {
      tile = false;
    }
    return this._resize(force_update_column_size = false, tile_for_update = tile);
  };

  Tile.prototype._update_dom = function(dom, column, col_index, row_index, update_left, update_top) {
    var nleft, ntop;
    if (update_left == null) {
      update_left = false;
    }
    if (update_top == null) {
      update_top = false;
    }
    ntop = 0;
    nleft = 0;
    if (update_left) {
      nleft = this.padding + this.container.offset().left + this.tile_width * col_index;
    } else {
      nleft = column.left;
    }
    if (update_top) {
      ntop = this.container.offset().top + column.height;
    } else {
      ntop = dom.offset().top;
    }
    dom.offset({
      top: ntop,
      left: nleft
    });
    if (update_top) {
      column.height += dom.height();
      this.heights[col_index] = column.height;
      if (this.max_height < column.height) {
        this.max_height = column.height;
        return this.container.height(this.max_height);
      }
    }
  };

  Tile.prototype._add_dom = function(dom) {
    var col_index, column, row_index, update_left, update_top;
    dom = $(dom);
    col_index = _.indexOf(this.heights, _.min(this.heights));
    column = this.columns[col_index];
    column.rows.push(dom);
    row_index = column.rows.length - 1;
    dom.data('puicolindex', col_index);
    dom.data('puirowindex', row_index);
    dom.data('puienabled', true);
    return this._update_dom(dom, column, col_index, row_index, update_left = false, update_top = true);
  };

  Tile.prototype._resize = function(force_update_column_size, tile_for_update) {
    var col_index, column, dom, i, puienabled, row_index, should_update_column_size, should_update_left, update_left, update_top, _i, _j, _k, _l, _len, _len1, _m, _ref, _ref1, _ref2, _ref3, _ref4, _results, _results1, _results2;
    if (force_update_column_size == null) {
      force_update_column_size = false;
    }
    if (tile_for_update == null) {
      tile_for_update = false;
    }
    this.col_num = Math.floor(this.container.width() / this.tile_width);
    should_update_column_size = true;
    should_update_left = false;
    if (this.container_width !== this.container.width()) {
      should_update_left = true;
      this.container_width = this.container.width();
    }
    if (!force_update_column_size && this.columns.length !== 0 && this.col_num === this.columns.length) {
      should_update_column_size = false;
    }
    this.padding = (this.container.width() - (this.col_num * this.tile_width)) / 2;
    if (should_update_column_size) {
      this.columns = [];
      this.heights = [];
      this.max_height = 0;
      for (i = _i = 0, _ref = this.col_num - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        column = {
          height: 0,
          rows: [],
          left: this.padding + this.container.offset().left + this.tile_width * i,
          col_index: i
        };
        this.columns.push(column);
        this.heights.push(0);
      }
      col_index = 0;
      _ref1 = this.get_tiles_handler();
      _results = [];
      for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
        dom = _ref1[_j];
        _results.push(this._add_dom(dom));
      }
      return _results;
    } else {
      if (tile_for_update) {
        puienabled = tile_for_update.data('puienabled');
        if (!puienabled) {
          return this._add_dom(tile_for_update);
        } else {
          col_index = parseInt(tile_for_update.data('puicolindex'), 10);
          row_index = parseInt(tile_for_update.data('puirowindex'), 10);
          column = this.columns[col_index];
          if ((column.rows.length - 1) <= row_index) {
            return;
          }
          column.height = 0;
          for (i = _k = 0; 0 <= row_index ? _k <= row_index : _k >= row_index; i = 0 <= row_index ? ++_k : --_k) {
            dom = column.rows[i];
            column.height += dom.height();
          }
          _results1 = [];
          for (i = _l = _ref2 = row_index + 1, _ref3 = column.rows.length - 1; _ref2 <= _ref3 ? _l <= _ref3 : _l >= _ref3; i = _ref2 <= _ref3 ? ++_l : --_l) {
            dom = column.rows[i];
            _results1.push(this._update_dom(dom, column, col_index, row_index, update_left = false, update_top = true));
          }
          return _results1;
        }
      } else {
        _ref4 = this.get_tiles_handler();
        _results2 = [];
        for (_m = 0, _len1 = _ref4.length; _m < _len1; _m++) {
          dom = _ref4[_m];
          dom = $(dom);
          puienabled = dom.data('puienabled');
          if (!puienabled) {
            utils.log(puienabled);
            _results2.push(this._add_dom(dom));
          } else if (should_update_left) {
            col_index = parseInt(dom.data('puicolindex'), 10);
            row_index = parseInt(dom.data('puirowindex'), 10);
            column = this.columns[col_index];
            _results2.push(this._update_dom(dom, column, col_index, 0, update_left = true, update_top = false));
          } else {
            _results2.push(void 0);
          }
        }
        return _results2;
      }
    }
  };

  return Tile;

})();
