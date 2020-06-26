require('@rails/ujs').start()
require('turbolinks').start()

import 'bootstrap'
import '../stylesheets/application'

require.context('../images', true)

// Load all JS on every page here, via this single entry point.
// It's possible to do this better, either conditionally, or with separate packs,
// but there are lots of gotchas for potentially minimal performance gain.
// Currently on step 1 of this: https://stackoverflow.com/a/59495659/4741698
import '../graphs/bar_chart'
import '../graphs/line_graph'
