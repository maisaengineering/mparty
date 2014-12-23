$ ->
  $("#review_form").bind "ajax:beforeSend", ->
    $("#send_comment").attr("disabled", "disabled").val "..."

  # after message send enable send button and clear input
  $("#review_form").bind "ajax:success", ->
    $("#review_content").val ""
    $("#send_comment").removeAttr("disabled").val "Post"


$(document).ready ->
  $("#reviews .page").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#reviews div.review"


