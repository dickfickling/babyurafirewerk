module.exports =
  devtool: 'eval'
  progress: true
  output  :
    filename   : '[name].js'
    path       : '/dist/'
    publicPath : '/cast/dist/'
  module  :
    loaders: [
      test    : /\.(coffee|.cjsx)$/
      loaders : ['react-hot',  'coffee', 'cjsx']
    ]
  resolve :
    extensions: ['', '.js', '.jsx', '.coffee', '.cjsx', '.css', '.json']
