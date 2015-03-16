$ ->
  $("#comment_form").bind "ajax:beforeSend", ->
    $("#send_comment").attr("disabled", "disabled").val "..."

  # after message send enable send button and clear input
  $("#comment_form").bind "ajax:success", ->
    $("#comment_content").val ""
    $("#send_comment").removeAttr("disabled").val "Post"