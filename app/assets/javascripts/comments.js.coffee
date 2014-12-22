$ ->
  $("#comment_form").bind "ajax:beforeSend", ->
    $("#send_comment").attr("disabled", "disabled").val "..."

  # after message send enable send button and clear input
  $("#comment_form").bind "ajax:success", ->
    $("#comment_content").val ""
    $("#send_comment").removeAttr("disabled").val "Post"





$(document).ready ->
  $("#comments .page").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#comments div.comment"