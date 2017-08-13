_ = require 'lodash'
derbyServer = require '@dmapper/dm-derby-server'
conf = require 'nconf'
middle = null

# Add Rich Text support to ShareDB server-side
ShareDB = require 'sharedb'

module.exports = (done) ->

  derbyServer.init().run

    apps:
      require \
        '../node_modules/@dmapper/dm-derby-server/derbyAppsLoader!../derbyApps'
    beforeStart: beforeStart
    loginUrl: '/'
    bodyParserLimit: '5mb'

  , (ee) ->
    middle = require './middle'

    ee.on 'middleware', (expressApp) ->
      expressApp.use require('@dmapper/dm-timesync/server')()

    ee.on 'routes', (expressApp) ->
      expressApp.use require './routes'

    ee.on 'done', ->
      done?()

beforeStart = (backend, cb) ->
  cb()
