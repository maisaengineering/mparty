# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#trending_events .page").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#trending_events div.trending_event"





  $("#events .page").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#events div.event"

  $("#public_events .page").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#public_events div.public_event"

  $("#past_events .page").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#past_events div.past_event"


$(document).on 'ajax:beforeSend', '.ask_host_to_invite', ->
  bootbox.alert 'Request Sent successfully'
  $(this).remove()
  return
$(document).on 'ajax:success', '.ask_host_to_invite', ->
  $('.loading-indicator').hide()
  return

$(document).ready ->
  $(".fancybox").fancybox()
  $(".fancybox-media").attr("rel", "media-gallery").fancybox
    openEffect: "none"
    closeEffect: "none"
    prevEffect: "none"
    nextEffect: "none"
    arrows: false
    helpers:
      media: {}
      buttons: {}
