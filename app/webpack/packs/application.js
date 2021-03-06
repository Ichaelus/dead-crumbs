import '@babel/polyfill'
import 'dom4'
import 'unpoly/dist/unpoly.js'
import 'unpoly/dist/unpoly-bootstrap3.js'
import Rails from 'rails-ujs'

// Javascript
Rails.start()

let webpackContext = require.context('../javascripts', true, /\.js$/)
for(let key of webpackContext.keys()) { webpackContext(key) }

// Images
require.context('../images', true, /\.(?:png|jpg|gif|ico|svg)$/)

// Styles
import '../stylesheets/application'
import '../stylesheets/bootstrap'
import '../stylesheets/unpoly'

require.context('../stylesheets/blocks', true, /\.sass$/)
require.context('../stylesheets/ext', true, /\.sass$/)
