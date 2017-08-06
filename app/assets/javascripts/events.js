import MlborderEventBorderBox from 'components/events/borders/box.js.jsx';
import MlborderEventRecordBox from 'components/events/records/box.js.jsx';
import { mountComponents } from 'react-rails-ujs';

$(document).on('turbolinks:load', () => {
  mountComponents({
    MlborderEventBorderBox,
    MlborderEventRecordBox
  });

  $('button#default_series_button').on('click', (e) => {
    const event_id = $('#event_id').text();
    $.get(`/events/${event_id}/default_series_name`, (data) => {
      $('input#series_name').val(data['series_name']);
    });
  });

  $('form').on('click', '.remove_fields', function (e) {
    e.preventDefault();
    $('input[type=hidden]', $(this).parents('.input-group')).val('true');
    $(this).closest('.input-group').hide()
  });

  $('form').on('click', '.add_fields', function (e) {
    e.preventDefault();
    const time = new Date().getTime();
    const regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
  });

  $('#recent_border').on('click', (e) => {
    const event_id = $('#event_id').text();
    $.post(`/events/${event_id}/borders/recent`, (data) => {
      alert(data.message);
    });
  });
});
