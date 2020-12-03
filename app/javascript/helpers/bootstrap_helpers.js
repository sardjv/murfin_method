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
  $('select').selectpicker({ width: 'fit', liveSearch: true });
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
  const selectedTypeId = $(select).attr('data-tag-type-id');
  const childSelect = $(select).closest('.nested-fields').find('select.filter-child-select[data-tag-type-parent-id=' + selectedTypeId + ']');

  // Show all options.
  childSelect.find('option').prop('disabled', false).show();

  // Hide all child options which are not children of the selected parent.
  childSelect.find('option').filter('[data-parent-id!="' + selectedId + '"]').prop('selected', false).prop('disabled', true).hide();

  // Show empty option.
  childSelect.find('option').filter('[value=""]').prop('disabled', false).show();

  // Refresh the JS select overlay.
  childSelect.selectpicker('refresh');

  // Prevent dropdown carets getting stuck pointing up, for some reason.
  $('div.bootstrap-select').removeClass('dropup');

  // Trigger change on the child select, so that any descendants get updated too.
  childSelect.trigger('change');
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
