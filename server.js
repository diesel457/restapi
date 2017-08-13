require('events').EventEmitter.prototype._maxListeners = 100;
console.log('Starting server...');
require('./server/index')();
