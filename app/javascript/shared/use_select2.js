const useSelect2Selector = 'select[data-use-select2=true]'

const useSelect2 = () => {
  $(useSelect2Selector).each(function() {
    $(this).select2({
      // minimumInputLength: 3, // for more clear debug
      templateSelection: select2FormatTagSelection,
      matcher: select2CustomMatcher
    })
  })
}

function select2CustomMatcher(params, data) {
  // `params.term` should be the term that is used for searching
  // `data.text` is the text that is displayed for the data object
  let termString = $.trim(params.term)
  let textString = $.trim(data.text)

  // if there are no search terms, return all of the data
  if (termString === '') {
    return data
  }

  // do not display the item if there is no 'text' property
  if (typeof textString === 'undefined') {
    return null
  }

  if (termString) termString = termString.toUpperCase()
  if (textString) textString = textString.toUpperCase()

  let modifiedData = null;

  // search through optgroups first
  if (textString.indexOf(termString) > -1) {
    return data
  }

  // search through options

  // skip if there is no 'children' property
  if (typeof data.children === 'undefined') {
    return null
  }

  // `data.children` contains the actual options that we are matching against
  let filteredChildren = []
  $.each(data.children, function (idx, child) {
    if (child.text.toUpperCase().indexOf(termString) > -1) {
      filteredChildren.push(child)
    }
  });

  // If we matched any of the children, then set the matched children on the group and return the group object
  if (filteredChildren.length) {
    modifiedData = $.extend({}, data, true)
    modifiedData.children = filteredChildren

    // You can return modified objects from here
    // This includes matching the `children` how you want in nested data sets
    return modifiedData
  }

  return null
}

const select2FormatTagSelection = (tag_selection) => {
  const parentEl = tag_selection.element.parentElement
  const result = (parentEl !== undefined && parentEl.localName == 'optgroup' && parentEl.label !== undefined) ?
    `${parentEl.label}: ${tag_selection.text}` :
    tag_selection.text

  return result
}

document.addEventListener('turbo:load', () => useSelect2() )

document.addEventListener('turbo:before-cache', () => {
  $(useSelect2Selector).each(function() {
    $(this).select2('destroy')
  })
})