$(document).on 'ajax:beforeSend', '#new_review', ->
  $('.loading-indicator').show()

# after message send enable send button and clear input
$(document).on 'ajax:success', '#new_review', ->
  $('.loading-indicator').hide()

$(document).on 'click', '#btnSubmitReview', ->
  $('#new_review').submit()
  return

$(document).ready ->
  $("#reviews .page").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#reviews div.review"


