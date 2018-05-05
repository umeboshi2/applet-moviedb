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

{ posterImage } = require '../templates'

SeasonView = require './episodes'


MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'moviedb'

baseImageUrl = "https://image.tmdb.org/t/p/"

class InfoView extends Marionette.View
  template: tc.renderable (model) ->
    posterImage model
    tc.div ->
      tc.text model.overview
    if model.air_date
      date = new Date(model.air_date).toDateString()
      tc.span "Season started #{date}"
    tc.div '.jview'
  ui:
    jsonView: '.jview'
  onDomRefresh: ->
    @jsonView = new JView @model.toJSON()
    @ui.jsonView.prepend @jsonView.dom
    

class SeasonEntry extends Marionette.View
  className: 'season-entry listview-list-entry'
  attributes: ->
    data:
      'season-id': @model.id
  template: tc.renderable (season) ->
    tc.div '.entry-header', ->
      tc.div '.btn-group', ->
        tc.button '.info-button.btn.btn-info', type:'button', ->
          tc.i '.fa.fa-info.mr-1'
          tc.span 'info'
        tc.button '.episodes-button.btn.btn-primary', type:'button', ->
          tc.i '.fa.fa-tv.mr-1'
          tc.span 'episodes'
      tc.span '.season-name.ml-3', ->
        tc.text season.name
    tc.div '.info-container'
    tc.div '.season-container'
  ui:
    entryHeader: '.entry-header'
    episodesButton: '.episodes-button'
    infoButton: '.info-button'
    seasonName: '.season-name'
    seasonContainer: '.season-container'
    infoContainer: '.info-container'
  regions:
    seasonContainer: '@ui.seasonContainer'
    infoContainer: '@ui.infoContainer'
  events:
    'click @ui.episodesButton': 'episodesClicked'
    'click @ui.infoButton': 'infoClicked'
  initialize: (options) ->
    super options
    TvSeasonDetails = AppChannel.request 'TvSeasonDetails'
    @detailsModel = new TvSeasonDetails
      id: @model.get 'season_number'
    @detailsModel.tvId = @getOption 'tvId'

  episodesClicked: ->
    seasonContainer = @getRegion 'seasonContainer'
    if seasonContainer.hasView()
      console.log "seasonContainer", seasonContainer
      @ui.seasonContainer.toggle()
    else
      console.log "Checking model", @detailsModel, @detailsModel.has 'name'
      if not @detailsModel.has 'name'
        resp = @detailsModel.fetch
          data:
            append_to_response: 'images'
        resp.done =>
          @showSeasonView()
          @ui.entryHeader.addClass 'bg-dark text-white'
      else
        @showSeasonView()
      
  infoClicked: ->
    region = @getRegion 'infoContainer'
    if region.hasView()
      @ui.infoContainer.toggle()
    else
      view = new InfoView
        model: @model
      region.show view
    span = @ui.infoButton.children 'span'
    text = span.text()
    if text is 'info'
      span.text 'hide'
    else
      span.text 'info'
     
  showSeasonView: =>
    view = new SeasonView
      model: @detailsModel
    @showChildView 'seasonContainer', view
    
class SeasonsView extends Marionette.View
  className: 'col-md-12'
  template: tc.renderable (model) ->
    count = model.number_of_seasons or 0
    seasons = "Seasons"
    if count == 1
      seasons = "Season"
      
    tc.div '.listview-header', " #{count} #{seasons}"
    tc.div '.season-list'
  ui: ->
    seasonList: '.season-list'
  regions: ->
    seasonList: '@ui.seasonList'
  onRender: ->
    view = new Marionette.CollectionView
      childView: SeasonEntry
      childViewOptions:
        tvId: @model.id
      collection: new Backbone.Collection @model.get 'seasons'
    @showChildView 'seasonList', view

module.exports = SeasonsView

