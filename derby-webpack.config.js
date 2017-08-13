var derbyApps = require('./derbyApps');
var derbyAppsLoader = require('@dmapper/dm-derby-server/derbyAppsLoader');

module.exports = {
    moduleMode: true,
    apps: derbyAppsLoader.whitelistedDerbyApps(derbyApps),
    npmScopes: ['@dmapper'],
    includeList: [
        "@dmapper/dm-form",
        "@dmapper/dm-timesync",
        "@dmapper/dm-ui",
        "@dmapper/dm-util"
    ],
    backendApps: {
        server: __dirname + '/server'
    },
    frontend: {
        devtool: 'cheap-module-eval-source-map'
    },
    backend: {
        devtool: (process.env.fast ? 'cheap-module-eval-source-map' : 'source-map')
    },
    resolve: {
        alias: {
            '~': __dirname
        }
    },
    stylus: {
        import: [
            __dirname + '/styles/colors',
            __dirname + '/styles/variables'
        ]
    },
    webpackPort: process.env.DEVSERVER_PORT || 3010
};