webpack       = require 'webpack'
express       = require 'express'
MemoryFS      = require 'memory-fs'
config        = require './webpack-config'
fs            = new MemoryFS()

config.entry =
  display: './src/display'
  client: './src/client'

compiler = webpack config

compiler.outputFileSystem = fs

module.exports = app = express()

compiler.run (err, stats) ->
  (filename for filename of stats.compilation.assets).map (filename) ->
    fullPath = "#{config.output.path}#{filename}"
    js = fs.readFileSync fullPath, 'utf-8'

    app.use fullPath, (req, res) ->
      res.set 'Content-Type', 'application/javascript'
      res.send js
