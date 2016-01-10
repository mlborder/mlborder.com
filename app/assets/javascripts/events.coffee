# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
    area = $('#event_default_series_area')
    $('button', area).on 'click', (e) =>
        event_id = $('#event_id').text()
        $.get "/events/#{event_id}/default_series_name", (data) =>
            $('input', area).val(data['series_name'])
