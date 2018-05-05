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

{ movieTemplate } = require '../templates'
  
SeasonsView = require './seasons'
CreditsView = require './credits'


MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'moviedb'
      
    
class ShowView extends Marionette.View
  template: tc.renderable (model) ->
    movieTemplate model
    tc.div '.credits'
    
  templateContext:
    imgClass: '.card-img-bottom'
  ui:
    jsonView: '.jsonview'
    creditsContainer: '.credits'
  regions:
    credits: '@ui.creditsContainer'
  onRender: ->
    view = new CreditsView
      model: @model
    @showChildView 'credits', view
  onDomRefresh: ->
    @jsonView = new JView @model.toJSON()
    @ui.jsonView.prepend @jsonView.dom

module.exports = ShowView


