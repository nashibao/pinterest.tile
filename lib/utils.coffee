this.utils ?= {}
utils = this.utils
utils.debug = true

utils.log = (obj) ->
  if utils.debug
    console.log obj

utils.getJSON = (url, callback) ->
    opts = {
        url: url
        type: 'GET'
        traditional: true
        cache: true
        data: {}
        dataType: 'json'
        success: (data, dataType) ->
            utils.log data
            callback data
    }
    $.ajax opts
