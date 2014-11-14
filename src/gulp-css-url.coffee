through = require 'through2'
{ PluginError, File } = require 'gulp-util'
{ dirname, basename, extname, relative, join, resolve } = require 'path'
{ isObject, isNumber, isString, clone, merge } = require 'lodash'

PLUGIN_NAME = 'gulp-css-url'

log = (task, action, path) ->
    gutil.log "#{ gutil.colors.cyan(task) }: [#{ gutil.colors.blue(action) }] #{ gutil.colors.magenta(path) }"

defOpts =
  mode: 'relative'
  base: '.'

module.exports = (opts = {}) ->
  opts = merge clone(defOpts), opts

  rootPath = resolve process.cwd(), opts.base

  switch opts.mode

    when 'relative'
      through objectMode: true, (file, enc, callback) ->
        if file.isNull()
          @push file
          callback()
          return

        if file.isBuffer()
          cssPath = dirname file.path
          css = file.contents.toString()
          css = css.replace /url\s*\(\s*['"]?(\/.*?)['"]?\s*\)/g, (matched, absPath) ->
            imagePath = resolve rootPath, ".#{absPath}"
            relPath = relative cssPath, imagePath
            """url("#{relPath}")"""
          file.contents = new Buffer css
          @push file
          callback()
          return

        throw new PluginError PLUGIN_NAME, 'Stream is not supported' if file.isStream()

    when 'absolute'
      through objectMode: true, (file, enc, callback) ->
        if file.isNull()
          @push file
          callback()
          return

        if file.isBuffer()
          cssPath = file.base
          css = file.contents.toString()
          css = css.replace /url\s*\(\s*['"]?([^\/].*?)['"]?\s*\)/g, (matched, relPath) ->
            imagePath = resolve cssPath, relPath
            absPath = relative rootPath, imagePath
            """url("/#{absPath}")"""
          file.contents = new Buffer css
          @push file
          callback()
          return

        throw new PluginError PLUGIN_NAME, 'Stream is not supported' if file.isStream()

    else
      throw new PluginError PLUGIN_NAME, "Mode '#{opts.mode}' is not supported"
