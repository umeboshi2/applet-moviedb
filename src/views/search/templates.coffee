tc = require 'teacup'

{ form_group_input_div } = require 'tbirds/templates/forms'

tvSearchForm = tc.renderable ->
  form_group_input_div
    input_id: 'input_query'
    label: 'TV Show'
    input_attributes:
      name: 'query'
      placeholder: 'Enter a TV show'
      'data-validation': 'query'
  tc.input '.submit-btn.btn.btn-primary.btn-sm', type:'submit', value:'Search'
  tc.div '.spinner.fa.fa-spinner.fa-spin.text-primary'


movieSearchForm = tc.renderable ->
  form_group_input_div
    input_id: 'input_query'
    label: 'Movie Search'
    input_attributes:
      name: 'query'
      placeholder: 'Enter a query such as "gone with the wine"'
  tc.input '.submit-btn.btn.btn-primary.btn-sm', type:'submit', value:'Search'
  tc.div '.spinner.fa.fa-spinner.fa-spin.text-primary'


    
module.exports =
  tvSearchForm: tvSearchForm
  movieSearchForm: movieSearchForm
