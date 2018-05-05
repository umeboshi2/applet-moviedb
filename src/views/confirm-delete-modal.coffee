import Backbone from 'backbone'
import Marionette from 'backbone.marionette'
import tc from 'teacup'

MessageChannel = Backbone.Radio.channel 'messages'

defaultHeader = tc.renderable (model) ->
  tc.h3 '.modal-title', ->
    tc.text "Do you really want to delete this?"
  tc.button '.close', type:'button', data:{dismiss:'modal'}, ->
    tc.span "aria-hidden":"true", ->
      tc.raw '&times'

defaultBody = tc.renderable (model) ->
  tc.div()
  
ConfirmDeleteTemplate = tc.renderable (model) ->
  tc.div '.modal-content', ->
    tc.div '.modal-header', ->
      el = model.headerTemplate or defaultHeader
      el model
    tc.div '.modal-body', ->
      el = model.modalBodyTemplate or defaultBody
      el model
    tc.div '.modal-footer', ->
      tc.button '.confirm-delete.btn.btn-primary',
      type:'button', data:{dismiss:'modal'}, ->
        tc.i '.fa.fa-check'
        tc.text "OK"
      tc.button '.cancel-delete.btn.btn-danger',
      type:'button', data:{dismiss:'modal'}, ->
        tc.i '.fa.fa-close'
        tc.text "Cancel"

export default class ConfirmDeleteModal extends Marionette.View
  template: ConfirmDeleteTemplate
  className: 'modal-dialog'
  ui:
    confirmDelete: '.confirm-delete'
    cancelButton: '.cancel-delete'
    
  events: ->
    'click @ui.confirmDelete': 'confirmDelete'

  confirmDelete: ->
    name = @model.get 'name'
    response = @model.destroy()
    response.done ->
      MessageChannel.request 'success', "#{name} deleted.",
    response.fail ->
      MessageChannel.request 'danger', "#{name} NOT deleted."
      
