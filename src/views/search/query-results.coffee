$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
JView = require 'json-view'
require 'json-view/devtools.css'

# FIXME
window.jQuery = $
require 'bootstrap-star-rating/css/star-rating.css'
require 'bootstrap-star-rating/themes/krajee-fa/theme.css'
starRating = require 'bootstrap-star-rating/js/star-rating'
require 'bootstrap-star-rating/themes/krajee-fa/theme.js'

navigate_to_url = require('tbirds/util/navigate-to-url').default

noImage = require('tbirds/templates/no-image-span').default
HasHeader = require('tbirds/behaviors/has-header').default

{ posterImage
  tvShowDescription } = require '../templates'
  
MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'moviedb'


class ResultEntryView extends Marionette.View
  ui:
    selectResult: '.select-result'
    rating: '.rating'
  events:
    'click @ui.selectResult': 'selectResult'
  inLocalCollection: ->
    id = @model.toJSON().show.id
    collection = @getOption 'localCollection'
    return collection.get id
  onRender: ->
    if true or not @inLocalCollection()
      @ui.selectResult.show()
    rating = @model.get 'vote_average'
    @ui.rating.rating
      min: 1
      max: 10
      theme: 'krajee-fa'
      readonly: true
      size: 'xs'
    #@ui.rating.rating 'upate', 3
    
  handleImageHover: ->
    if true or @inLocalCollection()
      @ui.mainImage.css
        cursor: 'pointer'
  selectResult: ->
    id = @model.toJSON().id
    urlRoot = @getOption 'entryUrlRoot'
    navigate_to_url "#{urlRoot}/#{id}"

class SearchResultsView extends Marionette.View
  template: tc.renderable (model) ->
    tc.div '.results-header.listview-header', ->
      tc.text "Matched Movies"
    tc.div '.result-list'
  ui:
    header: '.results-header'
    itemList: '.result-list'
  regions:
    itemList: '@ui.itemList'
  behaviors:
    HasHeader:
      behaviorClass: HasHeader
  onRender: ->
    @ui.header.hide()
    view = new Marionette.CollectionView
      collection: @collection
      childView: ResultEntryView
      childViewOptions:
        localCollection: new Backbone.Collection
        entryUrlRoot: @getOption 'entryUrlRoot'
        template: @getOption 'entryTemplate'
    @showChildView 'itemList', view

module.exports = SearchResultsView


