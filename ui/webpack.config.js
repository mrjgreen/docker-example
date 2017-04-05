var path = require('path')
var webpack = require('webpack')
var HtmlWebpackPlugin = require('html-webpack-plugin')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
var NoOpPlugin = {apply: function(){}}
var isProduction = process.env.NODE_ENV === 'production';

module.exports = {
  // Our main js file
  entry: './src/main.js',
  output: {
    // Built files will be placed here (need the resolve for the webpack dev server)
    path: path.resolve(__dirname, 'dist'),
    publicPath: "/",
    // In production we want to add the js file hash into the filename to cache bust
    filename: isProduction ? 'js/[name].[hash].js' : 'js/[name].js',
  },
  module: {
    rules: [
      {
        // Enable vue-js component transpiling, with support for css in the components
        test: /\.vue$/,
        loader: 'vue-loader',
        options: {
          loaders: {
            css: ExtractTextPlugin.extract({fallback: 'vue-style-loader', use: 'css-loader'}),
            scss: ExtractTextPlugin.extract({fallback: 'vue-style-loader', use: ['css-loader', 'sass-loader']}),
          }
        }
      },
      {
        // Enable css compiling, for imported CSS files
        test: /\.css$/,
        use: ExtractTextPlugin.extract({fallback: 'style-loader', use: 'css-loader'})
      },
      {
        // Enable scss compiling, for imported Sass files
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({fallback: 'style-loader', use: ['css-loader', 'sass-loader']})

      },
      {
        // Transpile any JS files accoring to our settings in .bablerc
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node_modules/
      },
      {
        // Copy any assets to our dist folder, adding the content hash to the filepath in production
        test: /\.(png|jpg|jpeg|gif|svg|eot|woff|woff2|ttf)$/,
        loader: 'file-loader',
        options: {
          name: isProduction ? 'img/[hash].[ext]' : 'img/[name].[ext]'
        }
      }
    ]
  },
  resolve: {
    alias: {
      // We don't need on-the-fly template compilation, so we don't need the full vue js lib
      'vue$': 'vue/dist/vue.esm.js',
      'theme': path.resolve(__dirname, 'src/assets/theme/')
    }
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        // Vue JS and webpack will use this to determine build mode
        NODE_ENV: JSON.stringify(process.env.NODE_ENV),

        // Application constants will be replaced in the code on build
        API_URL: JSON.stringify(process.env.API_URL)
      }
    }),
    // Enable hot module replacement when not in production
    !isProduction ? new webpack.HotModuleReplacementPlugin() : NoOpPlugin,
    // In production we want to minfy and uglify the code
    isProduction ? new webpack.optimize.UglifyJsPlugin({sourceMap: false}) : NoOpPlugin,
    // We always want our CSS to be pulled into separate CSS files, not embedded in the JS
    new ExtractTextPlugin(isProduction ? 'css/[name].[contenthash].css' : 'css/[name].css'),
    // Minify the CSS in production
    isProduction ? new OptimizeCssAssetsPlugin() : NoOpPlugin,
    // Automatically inject the correct asset links into our HTML index file, and copy to the dist folder
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: 'index.html',
      inject: true,
      minify: {
        removeComments: true,
        collapseWhitespace: true,
        removeAttributeQuotes: true
      },
    })
  ],
  devServer: {
    historyApiFallback: true,
    inline: true,
    hot: true
  }
}
