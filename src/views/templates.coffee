$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

noImage = require 'exports-loader!../assets/no-image-available.svg'

baseImageUrl = "https://image.tmdb.org/t/p/"

posterImage = tc.renderable (options) ->
  noImageSize = options.noImageSize or '5x'
  imgClass = options.imgClass or '.mr-3'
  imgWidth = options.imgWidth or 200
  if options?.poster_path
    url = "#{baseImageUrl}w#{imgWidth}#{options.poster_path}"
  else
    url = noImage
  tc.img imgClass, src:url, style:"width:#{imgWidth}px"
    
tvShowDescription = tc.renderable (model) ->
  tc.h3 '.mt-0', model.name
  premiered = new Date(model.first_air_date).toDateString()
  if premiered isnt "Invalid Date"
    tc.h5 "Premiered: #{premiered}"
  ended = new Date(model.last_air_date).toDateString()
  if ended isnt "Invalid Date"
    tc.h5 "Ended: #{ended}"
  tc.input '.rating', type:'number',
  style:'display:none', value:model.vote_average
  tc.p model.overview

movieDescription = tc.renderable (model) ->
  tc.h3 '.mt-0', model.title
  if model?.tagline
    tc.h5 "#{model.tagline}"
  released = new Date(model.release_date).toDateString()
  if released isnt "Invalid Date"
    tc.h5 "Released: #{released}"
  ended = new Date(model.last_air_date).toDateString()
  if ended isnt "Invalid Date"
    tc.h4 "Ended: #{ended}"
  tc.input '.rating', type:'number',
  style:'display:none', value:model.vote_average
  tc.p model.overview


objectJsonTemplate = tc.renderable ->
  tc.div '.jsonview.listview-list-entry', style:'overflow:auto'
    
    
showTemplateCard = tc.renderable (model) ->
  tc.div '.card.bg-body-d5', ->
    tc.div '.row', ->
      tc.div '.col-lg-3', ->
        posterImage model
      tc.div '.card-block.col-lg-8', ->
        tvShowDescription model


showTemplate = tc.renderable (model) ->
  showTemplateCard model
  tc.div '.seasons-row.row'
  tc.div '.row', ->
    tc.div '.col-md-12', ->
      objectJsonTemplate()



movieTemplateCard = tc.renderable (model) ->
  tc.div '.card.bg-body-d5', ->
    tc.div '.row', ->
      tc.div '.col-lg-3', ->
        posterImage model
      tc.div '.card-block.col-lg-8', ->
        movieDescription model
    
movieTemplate = tc.renderable (model) ->
  movieTemplateCard model
  tc.div '.row', ->
    tc.div '.col-md-12', ->
      objectJsonTemplate()

module.exports =
  noImage: noImage
  posterImage: posterImage
  tvShowDescription: tvShowDescription
  objectJsonTemplate: objectJsonTemplate
  showTemplateCard: showTemplateCard
  showTemplate: showTemplate
  movieTemplateCard: movieTemplateCard
  movieTemplate: movieTemplate


