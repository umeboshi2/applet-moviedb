import Backbone from 'backbone'
import Marionette from 'backbone.marionette'
import tc from 'teacup'
import ms from 'ms'

import ToolbarView from 'tbirds/views/button-toolbar'
import { MainController } from 'tbirds/controllers'
import { ToolbarAppletLayout } from 'tbirds/views/layout'
navigate_to_url = require 'tbirds/util/navigate-to-url'
scroll_top_fast = require 'tbirds/util/scroll-top-fast'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
ResourceChannel = Backbone.Radio.channel 'resources'
AppChannel = Backbone.Radio.channel 'moviedb'

class Controller extends MainController
  layoutClass: ToolbarAppletLayout
  viewIndex: ->
    return @searchTvShows()
    
  searchTvShows: ->
    Collection = AppChannel.request "SearchTvCollection"
    require.ensure [], () =>
      View = require './views/index-view'
      return @_viewSearch Collection, View
    # name the chunk
    , 'moviedb-view-index'
    
  searchMovies: ->
    Collection = AppChannel.request "SearchMovieCollection"
    require.ensure [], () =>
      View = require './views/search/movies'
      return @_viewSearch Collection, View
    # name the chunk
    , 'moviedb-search-movies'

  _viewSearch: (Collection, View) ->
    @setupLayoutIfNeeded()
    view = new View
      collection: new Collection
    @layout.showChildView 'content', view
    
  _viewEntity: (id, Model, View) ->
    @setupLayoutIfNeeded()
    model = new Model
      id: id
    response = model.fetch
      data:
        append_to_response: 'images,externals'
    response.done =>
      view = new View
        model: model
      @layout.showChildView 'content', view
      @scrollTop()
    
  viewTvShow: (id) ->
    Model = AppChannel.request 'TvDetails'
    require.ensure [], () =>
      View = require './views/tvshow'
      return @_viewEntity id, Model, View
    # name the chunk
    , 'moviedb-view-tv-show'

  viewMovie: (id) ->
    Model = AppChannel.request 'MovieDetails'
    require.ensure [], () =>
      View = require './views/movies'
      return @_viewEntity id, Model, View
    # name the chunk
    , 'moviedb-view-movie'
  
export default Controller

