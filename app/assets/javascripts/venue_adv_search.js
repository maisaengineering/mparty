function searchByFilters(){
    var event_types = $('input:checkbox:checked.event_types').map(function () {
        return this.value;
    }).get();
    var venue_types = $('input:checkbox:checked.venue_types').map(function () {
        return this.value;
    }).get();
    var number_of_people = $('input:checkbox:checked.number_of_people').map(function () {
        return this.value;
    }).get();
    var facilities = $('input:checkbox:checked.venue_facilities').map(function () {
        return this.value;
    }).get();
    var search_query =  $('#search_query').val()
    var relevance = $('#venues_by_relevance').val()
    var number_of_people = $('input[name=number_of_people]:checked').val();
    var from_event = $('#from_event').val();
    $.ajax({
        url: '/venues',
        type: "get",
        data: {query: search_query,event_types: event_types,venue_types: venue_types,number_of_people: number_of_people,facilities: facilities,
            relevance: relevance,from_event: from_event},
        dataType : 'script',
        beforeSend: function(e){  $('.loading-indicator').fadeIn('slow') },
        success:function (e) {  $('.loading-indicator').hide()  }
    })
}

$(document).on('click', '#EventType .event_types,#VenueType .venue_types,#NoOfPeople .number_of_people,#Facilities .venue_facilities', function(e) {
    searchByFilters()
})

$(document).on('change', '#venues_by_relevance', function(e) {
    searchByFilters()
})

$(document).on('click', '#venueFilter h4 span.glyphicon', function(e) {
    if( $(this).hasClass("glyphicon-plus")) {
        $(this).removeClass("glyphicon-plus");
        $(this).addClass("glyphicon-minus");
    }
    else {
        $(this).removeClass("glyphicon-minus");
        $(this).addClass("glyphicon-plus");
    }
})