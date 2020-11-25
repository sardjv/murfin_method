// Initial render.
window.addEventListener('turbolinks:load', () => {
  styleSelects()
  styleDurations()
});

// After nested form added.
$(document).on('cocoon:after-insert', () => {
  styleSelects()
  styleDurations()
});

function styleSelects() {
  $('select').selectpicker({ width: 'fit' });
  $('.rails-bootstrap-forms-datetime-select').addClass('form-inline');
  $('.rails-bootstrap-forms-date-select').addClass('form-inline');
}

function styleDurations() {
  $('.duration-picker').durationPicker({
    showDays: false,
    showSeconds: false
  });
}
