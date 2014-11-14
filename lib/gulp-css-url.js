var File, PLUGIN_NAME, PluginError, basename, clone, defOpts, dirname, extname, isNumber, isObject, isString, join, log, merge, relative, resolve, through, _ref, _ref1, _ref2;

through = require('through2');

_ref = require('gulp-util'), PluginError = _ref.PluginError, File = _ref.File;

_ref1 = require('path'), dirname = _ref1.dirname, basename = _ref1.basename, extname = _ref1.extname, relative = _ref1.relative, join = _ref1.join, resolve = _ref1.resolve;

_ref2 = require('lodash'), isObject = _ref2.isObject, isNumber = _ref2.isNumber, isString = _ref2.isString, clone = _ref2.clone, merge = _ref2.merge;

PLUGIN_NAME = 'gulp-css-url';

log = function(task, action, path) {
  return gutil.log("" + (gutil.colors.cyan(task)) + ": [" + (gutil.colors.blue(action)) + "] " + (gutil.colors.magenta(path)));
};

defOpts = {
  mode: 'relative',
  base: '.'
};

module.exports = function(opts) {
  var rootPath;
  if (opts == null) {
    opts = {};
  }
  opts = merge(clone(defOpts), opts);
  rootPath = resolve(process.cwd(), opts.base);
  switch (opts.mode) {
    case 'relative':
      return through({
        objectMode: true
      }, function(file, enc, callback) {
        var css, cssPath;
        if (file.isNull()) {
          this.push(file);
          callback();
          return;
        }
        if (file.isBuffer()) {
          cssPath = dirname(file.path);
          css = file.contents.toString();
          css = css.replace(/url\s*\(\s*['"]?(\/.*?)['"]?\s*\)/g, function(matched, absPath) {
            var imagePath, relPath;
            imagePath = resolve(rootPath, "." + absPath);
            relPath = relative(cssPath, imagePath);
            return "url(\"" + relPath + "\")";
          });
          file.contents = new Buffer(css);
          this.push(file);
          callback();
          return;
        }
        if (file.isStream()) {
          throw new PluginError(PLUGIN_NAME, 'Stream is not supported');
        }
      });
    case 'absolute':
      return through({
        objectMode: true
      }, function(file, enc, callback) {
        var css, cssPath;
        if (file.isNull()) {
          this.push(file);
          callback();
          return;
        }
        if (file.isBuffer()) {
          cssPath = file.base;
          css = file.contents.toString();
          css = css.replace(/url\s*\(\s*['"]?([^\/].*?)['"]?\s*\)/g, function(matched, relPath) {
            var absPath, imagePath;
            imagePath = resolve(cssPath, relPath);
            absPath = relative(rootPath, imagePath);
            return "url(\"/" + absPath + "\")";
          });
          file.contents = new Buffer(css);
          this.push(file);
          callback();
          return;
        }
        if (file.isStream()) {
          throw new PluginError(PLUGIN_NAME, 'Stream is not supported');
        }
      });
    default:
      throw new PluginError(PLUGIN_NAME, "Mode '" + opts.mode + "' is not supported");
  }
};
