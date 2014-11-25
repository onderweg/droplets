var connect = require('connect'),
    serveStatic = require('serve-static'),
    path = require('path');

var args = process.argv.slice(2);

var port = args[0];
var path = path.resolve(__dirname, '..', 'client');

console.log("starting server on port %s", port);

var app = connect();
app.use(serveStatic(path));
app.listen(port);