// jQuery is needed globally for JS views like 'app/views/notes/new.js.erb'.
global.$ = jQuery;

require('@rails/ujs').start()
require('turbolinks').start()
require('@nathanvda/cocoon')

import 'bootstrap'
import 'bootstrap-select';
import '../stylesheets/application'
import * as _ from 'lodash';

require.context('../images', true)

// Load all JS on every page here, via this single entry point.
// It's possible to do this better, either conditionally, or with separate packs,
// but there are lots of gotchas for potentially minimal performance gain.
// Currently on step 1 of this: https://stackoverflow.com/a/59495659/4741698
import '../graphs/api'
import '../helpers/bootstrap_duration'
import '../helpers/bootstrap_helpers'
import '../graphs/missing_data'
import '../graphs/bar_chart'
import '../graphs/line_graph'
import '../graphs/note'
