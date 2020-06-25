require('turbolinks').start();
require.context('../images', true)

import Rails from '@rails/ujs'
Rails.start()

import 'bootstrap';
import '../stylesheets/application';
