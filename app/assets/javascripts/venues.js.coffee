# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('.raty-cancel').css("display","none")

$(document).on 'click', '.reserve_this_venue_to_event', (e) ->
  e.preventDefault()
  url = '/venues/' + $(this).data('id') + '/check_availability'
  $.ajax
    url: url
    beforeSend: ->
      $('.loading-indicator').fadeIn 'slow'
      return
    success: (res) ->
      $('.loading-indicator').hide()
      return
  return


jQuery ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next a').attr('href')
      if url &&  $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text('Fetching more venues...')
        $.getScript(url)
  $(window).scroll()

