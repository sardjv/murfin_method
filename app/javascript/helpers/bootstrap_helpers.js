// Initial render.
window.addEventListener('turbolinks:load', () => {
  styleSelects()
  addDurationPickers()
});

// After nested form added.
$(document).on('cocoon:after-insert', () => {
  styleSelects()
  addDurationPickers()
});

function styleSelects() {
  $('select').selectpicker({ width: 'fit' });
  $('.rails-bootstrap-forms-datetime-select').addClass('form-inline');
  $('.rails-bootstrap-forms-date-select').addClass('form-inline');
}

function addDurationPickers() {
  $('.duration-picker').durationPicker({
    showDays: false,
    showSeconds: false
  });
}
