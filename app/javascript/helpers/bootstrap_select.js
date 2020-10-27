window.addEventListener('turbolinks:load', () => {
  styleSelects()
});

// For nested forms.
$(document).on('cocoon:after-insert', () => {
  styleSelects()
});

function styleSelects() {
  $('select').selectpicker({ width: 'fit' });
  $('.rails-bootstrap-forms-datetime-select').addClass('form-inline');
  $('.rails-bootstrap-forms-date-select').addClass('form-inline');
  $('.rails-bootstrap-forms-time-select').addClass('form-inline');
}
