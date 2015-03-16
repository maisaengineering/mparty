# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ajax:beforeSend', '.ask_host_to_invite', ->
  bootbox.alert 'Request sent successfully'
  $(this).remove()
  return
$(document).on 'ajax:success', '.ask_host_to_invite', ->
  $('.loading-indicator').hide()
  return

$(document).on 'ajax:beforeSend', '#new_event', ->
  $('.loading-indicator').show()
  return
$(document).on 'ajax:success', '#new_event', ->
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

  $('#venue_reservation_info').hide().fadeIn(1000)
