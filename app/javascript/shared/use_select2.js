const useSelect2Selector = 'select[data-use-select2]'

const useSelect2 = () => {
  $(useSelect2Selector).each(function() {
    $(this).select2({
      templateSelection: select2FormatTagSelection
    })
  })
}

const select2FormatTagSelection = (tag_selection) => {
  const parentEl = tag_selection.element.parentElement

  const result = (parentEl !== undefined && parentEl.localName == 'optgroup' && parentEl.label !== undefined) ?
    `${parentEl.label}: ${tag_selection.text}` :
    tag_selection.text

  return result
}

document.addEventListener('turbolinks:load', () => useSelect2() )

document.addEventListener('turbolinks:before-cache', () => {
  $(useSelect2Selector).each(function() {
    $(this).select2('destroy')
  })
})