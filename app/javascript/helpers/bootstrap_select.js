window.addEventListener('turbolinks:load', () => {
  $('select').selectpicker();
  $('.rails-bootstrap-forms-datetime-select').addClass('form-inline');
});

// For nested forms.
$(document).on('cocoon:after-insert', () => {
  $('select').selectpicker();
  $('.rails-bootstrap-forms-datetime-select').addClass('form-inline');
});
