$(document).on('turbolinks:load', () => {
  const area = $('#event_default_series_area');
  $('button', area).on('click', (e) => {
    const event_id = $('#event_id').text();
    $.get(`/events/${event_id}/default_series_name`, (data) => {
      $('input', area).val(data['series_name']);
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
});
