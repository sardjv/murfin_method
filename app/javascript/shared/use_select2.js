const useSelect2 = () => {
  const cssSelectorUseSelect2 = 'select[data-use-select2]'

  $(cssSelectorUseSelect2).each(function() {
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

// Called once after the initial page has loaded
document.addEventListener('turbolinks:load', () => useSelect2(), { once: true })

// Called after every non-initial page load
document.addEventListener('turbolinks:render', () => useSelect2() )
