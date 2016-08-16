module.exports =
  devtool: 'eval'
  progress: true
  output  :
    filename   : '[name].js'
    path       : '/dist/'
    publicPath : '/dist/'
  module  :
    loaders: [
      test    : /\.(coffee|.cjsx)$/
      loaders : ['react-hot',  'coffee', 'cjsx']
    ]
  resolve :
    extensions: ['', '.js', '.jsx', '.coffee', '.cjsx', '.css', '.json']
