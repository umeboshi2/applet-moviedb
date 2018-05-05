$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
marked = require 'marked'
PageableCollection = require 'backbone.paginator'


BootstrapFormView = require('tbirds/views/bsformview').default
{ form_group_input_div } = require 'tbirds/templates/forms'

QueryModel = require './query-model'

MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'moviedb'

class SearchFormView extends BootstrapFormView
  ui: ->
    query: '[name="query"]'
  initialize: (options) ->
    if false
      @initializeAutoSubmit()
    return super options
    
  initializeAutoSubmit: (options) ->
    @autoClickSubmitOnce = _.once @autoClickSubmit
    setTimeout =>
      @autoClickSubmitOnce()
    , 1000
  createModel: ->
    console.log "UIUI", @ui
    return new QueryModel
  updateModel: ->
    @model.set 'query', @ui.query.val()
  saveModel: ->
    query = @model.get 'query'
    @collection.queryParams.query = @model.get 'query'
    response = @collection.fetch()
    response.done =>
      console.log "saveModel response", response, @collection
      @trigger 'save:form:success', @model
    response.fail =>
      MessageChannel.request 'warning', "#{@tvshow} not found."
      @trigger 'save:form:failure', @model

  autoClickSubmit: =>
    @ui.submitButton.click()
    console.log "Submit clicked"
          
    
module.exports = SearchFormView

