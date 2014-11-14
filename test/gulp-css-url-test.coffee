require('chai').should()
url = require '../lib/gulp-css-url'
{ File } = require 'gulp-util'
{ PassThrough } = require 'stream'
{ resolve, join, extname } = require 'path'
{ readFileSync } = require 'fs'

cwd = process.cwd()

describe 'gulp-css-url', ->

  describe 'in buffer mode', ->

    it "should replace absolute to relative", (done) ->
      stream = url mode: 'relative'
      stream.on 'data', (file) ->
        file.contents.toString().should.equal """
        .test1 {
          background: url("../image/test.jpg") 0 0 no-repeat;
        }
        .test2 {
          background: url("../../../test.jpg") 0 0 no-repeat;
        }
        .test3 {
          background: url("test.jpg") 0 0 no-repeat;
        }
        .test4 {
          background: url("images/test.jpg") 0 0 no-repeat;
        }
        """
      stream.on 'end', ->
        done()
      stream.write new File
        path: resolve cwd, 'path/to/css/test.css'
        base: resolve cwd, 'path/to/css/'
        contents: new Buffer """
      .test1 {
        background: url(/path/to/image/test.jpg) 0 0 no-repeat;
      }
      .test2 {
        background: url(/test.jpg) 0 0 no-repeat;
      }
      .test3 {
        background: url(/path/to/css/test.jpg) 0 0 no-repeat;
      }
      .test4 {
        background: url(/path/to/css/images/test.jpg) 0 0 no-repeat;
      }
      """
      stream.end()

    it "should replace absolute to relative with base", (done) ->
      stream = url mode: 'relative', base: 'htdocs'
      stream.on 'data', (file) ->
        file.contents.toString().should.equal """
        .test1 {
          background: url("../image/test.jpg") 0 0 no-repeat;
        }
        .test2 {
          background: url("../../../test.jpg") 0 0 no-repeat;
        }
        .test3 {
          background: url("test.jpg") 0 0 no-repeat;
        }
        .test4 {
          background: url("images/test.jpg") 0 0 no-repeat;
        }
        """
      stream.on 'end', ->
        done()
      stream.write new File
        path: resolve cwd, 'htdocs/path/to/css/test.css'
        base: resolve cwd, 'htdocs/path/to/css/'
        contents: new Buffer """
      .test1 {
        background: url(/path/to/image/test.jpg) 0 0 no-repeat;
      }
      .test2 {
        background: url(/test.jpg) 0 0 no-repeat;
      }
      .test3 {
        background: url(/path/to/css/test.jpg) 0 0 no-repeat;
      }
      .test4 {
        background: url(/path/to/css/images/test.jpg) 0 0 no-repeat;
      }
      """
      stream.end()

    it "should replace relative to absolute", (done) ->
      stream = url mode: 'absolute'
      stream.on 'data', (file) ->
        file.contents.toString().should.equal """
          .test1 {
            background: url("/path/to/image/test.jpg") 0 0 no-repeat;
          }
          .test2 {
            background: url("/test.jpg") 0 0 no-repeat;
          }
          .test3 {
            background: url("/path/to/css/test.jpg") 0 0 no-repeat;
          }
          .test4 {
            background: url("/path/to/css/images/test.jpg") 0 0 no-repeat;
          }
          """
      stream.on 'end', ->
        done()
      stream.write new File
        path: resolve cwd, 'path/to/css/test.css'
        base: resolve cwd, 'path/to/css/'
        contents: new Buffer """
          .test1 {
            background: url(../image/test.jpg) 0 0 no-repeat;
          }
          .test2 {
            background: url(../../../test.jpg) 0 0 no-repeat;
          }
          .test3 {
            background: url(test.jpg) 0 0 no-repeat;
          }
          .test4 {
            background: url(images/test.jpg) 0 0 no-repeat;
          }
          """
      stream.end()

    it "should replace relative to absolute", (done) ->
      stream = url base: 'htdocs', mode: 'absolute'
      stream.on 'data', (file) ->
        file.contents.toString().should.equal """
          .test1 {
            background: url("/path/to/image/test.jpg") 0 0 no-repeat;
          }
          .test2 {
            background: url("/test.jpg") 0 0 no-repeat;
          }
          .test3 {
            background: url("/path/to/css/test.jpg") 0 0 no-repeat;
          }
          .test4 {
            background: url("/path/to/css/images/test.jpg") 0 0 no-repeat;
          }
          """
      stream.on 'end', ->
        done()
      stream.write new File
        path: resolve cwd, 'htdocs/path/to/css/test.css'
        base: resolve cwd, 'htdocs/path/to/css/'
        contents: new Buffer """
          .test1 {
            background: url(../image/test.jpg) 0 0 no-repeat;
          }
          .test2 {
            background: url(../../../test.jpg) 0 0 no-repeat;
          }
          .test3 {
            background: url(test.jpg) 0 0 no-repeat;
          }
          .test4 {
            background: url(images/test.jpg) 0 0 no-repeat;
          }
          """
      stream.end()
