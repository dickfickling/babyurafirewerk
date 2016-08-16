

#
# Log HTTP requests
#
module.exports = (req, res, next) ->
  console.log "#{req.ip} #{req.method} #{req.url}"
  next()
