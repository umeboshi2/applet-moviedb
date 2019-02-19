path = require 'path'

webpack = require 'webpack'
nodeExternals = require 'webpack-node-externals'
ManifestPlugin = require 'webpack-manifest-plugin'
StatsPlugin = require 'stats-webpack-plugin'
MiniCssExtractPlugin = require 'mini-css-extract-plugin'

BuildEnvironment = process.env.NODE_ENV or 'development'
if BuildEnvironment not in ['development', 'production']
  throw new Error "Undefined environment #{BuildEnvironment}"




# handles output filename for js and css
outputFilename = (ext) ->
  d = "[name].#{ext}"
  p = "[name].min.#{ext}"
  return
    development: d
    production: p
    

# set output filenames
WebPackOutputFilename = outputFilename 'js'
CssOutputFilename = outputFilename 'css'

# path to build directory
localBuildDir =
  development: "dist"
  production: "dist"

WebPackOutput =
  filename: WebPackOutputFilename[BuildEnvironment]
  #path: path.resolve 'build'
  library: 'applet-moviedb'
  libraryTarget: 'umd'

DefinePluginOpts =
  development:
    __DEV__: 'true'
    DEBUG: JSON.stringify(JSON.parse(process.env.DEBUG || 'false'))
    #__useCssModules__: 'true'
    __useCssModules__: 'false'
  production:
    __DEV__: 'false'
    DEBUG: 'false'
    #__useCssModules__: 'true'
    __useCssModules__: 'false'
    'process.env':
      'NODE_ENV': JSON.stringify 'production'
    
StatsPluginFilename =
  development: 'stats-dev.json'
  production: 'stats.json'

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# coffee
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

coffeeLoaderDevRule =
  test: /\.coffee$/
  use: ['coffee-loader']

coffeeLoaderTranspileRule =
  test: /\.coffee$/
  loader: 'coffee-loader'
  options:
    transpile:
      presets: ['env']
      plugins: ["dynamic-import-webpack"]

coffeeLoaderRule =
  development: coffeeLoaderTranspileRule
  production: coffeeLoaderTranspileRule

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# css
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
loadCssRule =
  test: /\.css$/
  use: ['style-loader', 'css-loader']

sassOptions =
  includePaths: [
    'node_modules/compass-mixins/lib'
    'node_modules/bootstrap/scss'
  ]
    
devCssLoader = [
  {
    loader: 'style-loader'
  },{
    loader: 'css-loader'
  },{
    loader: 'sass-loader'
    options: sassOptions
  }
]


miniCssLoader =
  [
    MiniCssExtractPlugin.loader
    {
      loader: 'css-loader'
    },{
      loader: "sass-loader"
      options: sassOptions
    }
  ]

buildCssLoader =
  development: devCssLoader
  production: miniCssLoader
  



#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# plugins
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

common_plugins = [
  new webpack.DefinePlugin DefinePluginOpts[BuildEnvironment]
  # FIXME common chunk names in reverse order
  # https://github.com/webpack/webpack/issues/1016#issuecomment-182093533
  new StatsPlugin StatsPluginFilename[BuildEnvironment], chunkModules: true
  new ManifestPlugin()
  # This is to ignore moment locales with fullcalendar
  # https://github.com/moment/moment/issues/2416#issuecomment-111713308
  new webpack.IgnorePlugin /^\.\/locale$/, /moment$/
  new MiniCssExtractPlugin
    filename: CssOutputFilename[BuildEnvironment]
  ]
    

extraPlugins = []
WebPackOptimization = {}


WebPackOptimization =
  splitChunks:
    chunks: 'async'

if BuildEnvironment is 'production'
  UglifyJsPlugin = require 'uglifyjs-webpack-plugin'
  OptimizeCssAssetsPlugin = require 'optimize-css-assets-webpack-plugin'
  WebPackOptimization.minimizer = [
   new OptimizeCssAssetsPlugin()
   new UglifyJsPlugin
     sourceMap: true
   ]
  


AllPlugins = common_plugins.concat extraPlugins

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# main config
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


WebPackConfig =
  mode: BuildEnvironment
  optimization: WebPackOptimization
  #entry:
  #  app: ['./src/index.coffee']
  output: WebPackOutput
  plugins: AllPlugins
  externals: [nodeExternals()]
  module:
    rules: [
      loadCssRule
      {
        test: /\.scss$/
        use: buildCssLoader[BuildEnvironment]
      }
      coffeeLoaderRule[BuildEnvironment]
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/
        use: [
          {
            loader: 'url-loader'
            options:
              limit: 10000
              mimetype: "application/font-woff"
              name: "[name]-[hash].[ext]"
          }
        ]
      }
      # FIXME combine next two rules
      {
        test: /\.(gif|png|eot|ttf)?$/
        use: [
          {
            loader: 'file-loader'
            options:
              limit: undefined
          }
        ]
      }
      {
        #test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/
        test: /\.(gif|png|ttf|eot|svg)(\?v=[a-z0-9]\.[a-z0-9]\.[a-z0-9])?$/
        use: [
          {
            loader: 'file-loader'
            options:
              limit: undefined
          }
        ]
      }
    ]
  resolve:
    extensions: [".wasm", ".mjs", ".js", ".json", ".coffee"]
  stats:
    colors: true
    modules: false
    chunks: true
    #maxModules: 9999
    #reasons: true


if BuildEnvironment is 'development'
  WebPackConfig.devtool = 'source-map'
      
module.exports = WebPackConfig
