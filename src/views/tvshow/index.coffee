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

{ showTemplate } = require '../templates'
  
SeasonsView = require './seasons'


MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'moviedb'
      
    
class ShowView extends Marionette.View
  template: showTemplate
  templateContext:
    imgClass: '.card-img-bottom'
  ui:
    jsonView: '.jsonview'
    episodesButton: '.episodes-button'
    saveEpisodesButton: '.save-episodes'
    episodesList: '.episode-list-region'
    seasonsRow: '.seasons-row'
  regions:
    seasonsRow: '.seasons-row'
    episodes: '@ui.episodesList'
  onRender: ->
    view = new SeasonsView
      model: @model
    @showChildView 'seasonsRow', view
  onDomRefresh: ->
    @jsonView = new JView @model.toJSON()
    @ui.jsonView.prepend @jsonView.dom

module.exports = ShowView


