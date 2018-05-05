$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
marked = require 'marked'
JView = require 'json-view'
require 'json-view/devtools.css'

BootstrapFormView = require('tbirds/views/bsformview').default
{ navigate_to_url } = require 'tbirds/util/navigate-to-url'
{ form_group_input_div } = require 'tbirds/templates/forms'

noImage = require('tbirds/templates/no-image-span').default
PointerOnHover = require('tbirds/behaviors/pointer-on-hover').default


MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'moviedb'

seasonEntryAnchorTemplate = tc.renderable (season) ->
  tc.a href:"#moviedb/tv/shows/season/view/#{season.id}", ->
    tc.text season.name
  
seasonEntryTemplate = tc.renderable (season) ->
  tc.div '.season-entry.listview-list-entry',
  data: 'season-id':season.id, ->
    seasonEntryAnchorTemplate season
    
baseImageUrl = "https://image.tmdb.org/t/p/"


class EpisodeView extends Marionette.View
  attributes:
    style:
      width: '20%'
      'border-style': 'solid'
      'border-width': '5px'
  className: 'card bg-body-d5'
  template: tc.renderable (model) ->
    tc.div '.row', ->
      tc.div '.col-lg-3', ->
        if model.still_path
          tc.img src:"#{baseImageUrl}w200#{model.still_path}"
        else noImage '4x'
      tc.div '.col-lg-8.ml-1', ->
        tc.span model.overview

class EpisodeEntry extends Marionette.View
  className: 'listview-list-entry'
  template: tc.renderable (model) ->
    tc.span model.name
    tc.div '.episode-container'
  ui:
    episodeContainer: '.episode-container'
  regions:
    episodeContainer: '@ui.episodeContainer'
  behaviors:
    PointerOnHover:
      behaviorClass: PointerOnHover
      #uiProperty: 'entryHeader'
  events:
    click: 'entryClicked'
  entryClicked: ->
    console.log "entryClicked"
    region = @getRegion 'episodeContainer'
    if region.hasView()
      @ui.episodeContainer.toggle()
    else
      view = new EpisodeView
        model: @model
      region.show view
      
    
class SeasonView extends Marionette.View
  template: tc.renderable (model) ->
    tc.div '.episode-list'
  ui: ->
    episodeList: '.episode-list'
  regions: ->
    episodeList: '@ui.episodeList'
  onRender: ->
    view = new Marionette.CollectionView
      childView: EpisodeEntry
      collection: new Backbone.Collection @model.get 'episodes'
    @showChildView 'episodeList', view
    console.log "EPisode VEW", view
  

module.exports = SeasonView

