module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    bower:
      install:
        options:
          targetDir: './tmp'
          install: true
          copy: true

    notify_hooks:
      options:
        enabled: true
        max_jshint_notifications: 5

    copy:
      js:
        files: [
          expand: true
          flatten: true
          src: ['./tmp/single/**']
          dest: './public/js/minified/'
          filter: 'isFile'
        ]
      bower_css:
        files: [
          expand: true
          flatten: true
          cwd: './tmp/css'
          src: ['**']
          dest: './styles/vendor/'
          filter: 'isFile'
        ]
        options: process: (content, srcpath) ->
          # Replace fonts path in ionic
          if /ionic\.css/.test(srcpath)
            content = content.replace /\.\.\/fonts\//g, '/fonts/vendor/'
          content
    uglify:
      options:
        report: 'min'
        preserveComments: false
      vendor_full:
        src: ['./tmp/full/**/*.js']
        dest: './tmp/full.js'
        filter: 'isFile'

    concat:
      options:
        separator: ';'
      vendor_min:
        files: [
          src: './tmp/min/**/*.js'
          dest: './tmp/min.js'
          filter: 'isFile'
          nonull: true
        ]
      vendor:
        files:
          './public/js/minified/vendor.min.js': [
            './tmp/full.js'
            './tmp/min.js'
          ]

    clean:
      options:
        force: true
      all: ['./public/js/minified/*'
            './src/const/json/*.json'
            './bower_components']
      js: ['./lib']
      tmp: ['./tmp']

    svg_sprite:
      main:
        expand: true
        cwd: './public/img/icons'
        src: ['**/*.svg']
        dest: './public/img/sprites'
        options:
          shape:
            id:
              generator: 'icon-%s'
          mode:
            symbol:
              dest: ''
              sprite: 'icons.svg'
              inline: true


  # Handle assets
  grunt.registerTask 'assets',
      ['bower', 'copy', 'uglify', 'concat', 'svg_sprite']

  require('load-grunt-tasks') grunt
  grunt.task.run 'notify_hooks'

  # Build all with dev configuration
  grunt.registerTask 'build',
      ['assets', 'clean:tmp']
