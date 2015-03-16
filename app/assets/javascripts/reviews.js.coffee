$(document).on 'ajax:beforeSend', '#new_review', ->
  $('.loading-indicator').show()

# after message send enable send button and clear input
$(document).on 'ajax:success', '#new_review', ->
  $('.loading-indicator').hide()

$(document).on 'click', '#btnSubmitReview', ->
  $('#new_review').submit()
  return



