webpack       = require 'webpack'
express       = require 'express'
devMiddleware = require 'webpack-dev-middleware'
hotMiddleware = require 'webpack-hot-middleware'
config        = require './webpack-config'

config.entry =
  display: ['webpack-hot-middleware/client', './src/display']
  client: ['webpack-hot-middleware/client', './src/client']
config.plugins = [ new webpack.HotModuleReplacementPlugin() ]

compiler = webpack config

module.exports = app = express()

app.use devMiddleware compiler,
  noInfo     : true
  lazy       : false
  publicPath : config.output.path

app.use hotMiddleware compiler
