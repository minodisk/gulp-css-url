# [gulp](http://gulpjs.com)-css-cache-bust [![NPM version][npm-image]][npm-url] [![Build status][travis-image]][travis-url] [![Coverage Status][coveralls-image]][coveralls-url]

> Transforms the path of `url()` to relative or absolute


## Install

```bash
$ npm install --save-dev gulp-css-url
```


## Usage

```js
var gulp = require('gulp');
var url = require('gulp-css-url');

gulp.task('default', function () {
  return gulp.src('index.css')
  .dest('path/to/dest')
  .pipe(url())
  .dest('path/to/dest');
});
```


## API

### url(options)

#### options.mode

Type: `string`

Default: `'relative'`

The mode of transform. When `'absolute'` is specified, this plugin transform the path of url to absolute.

#### options.base

Type: `string`

Default: `'.'`

The path of document root.


[npm-url]: https://npmjs.org/package/gulp-css-url
[npm-image]: https://badge.fury.io/js/gulp-css-url.svg
[travis-url]: http://travis-ci.org/minodisk/gulp-css-url
[travis-image]: https://secure.travis-ci.org/minodisk/gulp-css-url.svg?branch=master
[coveralls-image]: https://img.shields.io/coveralls/minodisk/gulp-css-url.svg
[coveralls-url]: https://coveralls.io/r/minodisk/gulp-css-url
