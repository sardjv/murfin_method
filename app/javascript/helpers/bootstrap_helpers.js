// Initial render.
window.addEventListener('turbolinks:load', () => {
  styleSelects();
  styleDurations();
});

// After nested form added.
$(document).on('cocoon:after-insert', () => {
  styleSelects();
  styleDurations();
});

function styleSelects() {
  $('select').selectpicker({ width: 'fit' });
  $('.rails-bootstrap-forms-datetime-select').addClass('form-inline');
  $('.rails-bootstrap-forms-date-select').addClass('form-inline');

  $('select.filter-child-select').each((_index, select) => {
    filterChildSelect(select);
  })
  $('select.filter-child-select').change(function() {
    filterChildSelect(this);
  });
}

function filterChildSelect(select) {
  const selectedOption = $(select).find('option:selected');
  const selectedId = selectedOption.attr('data-id');
  const selectedTypeId = selectedOption.attr('data-tag-type-id');
  const childOptions = $('option[data-tag-type-parent-id=' + selectedTypeId + ']');

  // Show all child options.
  childOptions.prop('disabled', false).show();

  // Hide all child options which aren't children of the selected parent.
  childOptions.filter('[data-parent-id!=' + selectedId + ']').prop('disabled', true).prop('selected', false).hide();

  // Refresh the JS select overlay.
  $('select.filter-child-select').selectpicker('refresh');
}

function styleDurations() {
  $('.duration-picker-time-range').durationPicker({
    showDays: false,
    showSeconds: false
  });
  $('.duration-picker-activity').durationPicker({
    showDays: false,
    showSeconds: false,
    maxHours: 99
  });
}
