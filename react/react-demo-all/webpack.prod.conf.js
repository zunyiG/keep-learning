var path = require('path')
var webpack = require('webpack')
var htmlWebpackPlugin = require('html-webpack-plugin')
var uglifyjsWebpackPlugin = require('uglifyjs-webpack-plugin')
var cleanWebpackPlugin = require('clean-webpack-plugin')
var MiniCssExtractPlugin = require('mini-css-extract-plugin')
var OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')

module.exports = {
  mode: 'production',

  devtool: 'cheap-module-source-map',

  entry: {
    app: [
      'react-hot-loader/patch',
      path.join(__dirname, './src/index.js')
    ]
  },

  resolve: {
    alias: {
      _public: path.join(__dirname, 'public'),
      _pages: path.join(__dirname, 'src/pages'),
      _components: path.join(__dirname, 'src/components'),
      _router: path.join(__dirname, 'src/router'),
      _redux: path.join(__dirname, 'src/redux'),
      _actions: path.join(__dirname, 'src/redux/actions'),
      _reducers: path.join(__dirname, 'src/redux/reducers'),
    }
  },

  module: {
    rules: [{
      test: /\.js$/,
      include: path.join(__dirname, 'src'),
      use: {
        loader: 'babel-loader?cacheDirectory=true'
      }
    }, {
      test: /\.(css|scss)$/,
      use: [
        MiniCssExtractPlugin.loader,
        {
          loader: 'css-loader',
          options: {
            importLoaders: 1,
            minimize: true
          }
        },
        'sass-loader'
      ]
    }, {
      test: /\.(png|jpg|jpeg|gif)$/,
      use: {
        loader: 'url-loader',
        options: {
          limit: 8192
        }
      }
    }]
  },

  plugins: [
    new htmlWebpackPlugin({
      fileName: 'index.html',
      template: path.join(__dirname, 'src/index.html'),
      chunksSortMode: 'none'
    }),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NamedModulesPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify('production')
      }
    }),
    new cleanWebpackPlugin(['dist']),
    new MiniCssExtractPlugin({
      filename: '[name].[hash].css',
      chunkFilename: '[id].[hash].css'
    })
  ],

  output: {
    filename: '[name].[hash].js',
    chunkFilename: '[name].[chunkhash].js',
    path: path.join(__dirname, 'dist'),
    publicPath: '/'
  },

  optimization: {
    minimizer: [
      new uglifyjsWebpackPlugin({
        cache: true,
        parallel: true,
        sourceMap: true
      }),
      new OptimizeCSSAssetsPlugin({})
    ],

    splitChunks: {
      cacheGroups: {
        vender: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vender',
          chunks: 'all'
        }
      }
    }
  }
}
