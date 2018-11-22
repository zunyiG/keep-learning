var path = require('path')
var webpack = require('webpack')
var htmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
  mode: 'development',

  devServer: {
    contentBase: path.join(__dirname, 'dist'),
    compress: true,
    port: 8080,
    hot: true
  },

  // https://webpack.docschina.org/configuration/devtool/#%E5%AF%B9%E4%BA%8E%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83
  // 绝大多数情况下都会是最好的选择 （生产环境）
  devtool: 'cheap-module-eval-source-map',

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
      test: /\.scss$/,
      use: [
        'style-loader',
        {
          loader: 'css-loader',
          options: {
            importLoaders: 1
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
      template: path.join(__dirname, 'src/index.html')
    }),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NamedModulesPlugin()
  ],

  output: {
    filename: '[name].[hash].js',
    chunkFilename: '[name].[chunkhash].js',
    path: path.join(__dirname, 'dist')
  },

  optimization: {
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
