# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
    area = $('#event_default_series_area')
    $('button', area).on 'click', (e) =>
        event_id = $('#event_id').text()
        $.get "/events/#{event_id}/default_series_name", (data) =>
            $('input', area).val(data['series_name'])

    $('form').on 'click', '.remove_fields', (e) ->
        $('input[type=hidden]', $(this).parents('.input-group')).val('true')
        $(this).closest('.input-group').hide()
        e.preventDefault()

    $('form').on 'click', '.add_fields', (e) ->
        time = new Date().getTime()
        regexp = new RegExp($(this).data('id'), 'g')
        $(this).before($(this).data('fields').replace(regexp, time))
        e.preventDefault()
