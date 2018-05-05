$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'


MessageChannel = Backbone.Radio.channel 'messages'
AppChannel = Backbone.Radio.channel 'moviedb'

class QueryModel extends Backbone.Model
  validation:
    query:
      required: true
      minLength: 11
      
module.exports = QueryModel


