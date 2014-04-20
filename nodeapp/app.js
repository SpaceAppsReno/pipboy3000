var
	express = require('express'),
	WebSocket = require('ws'),
	WebSocketServer = WebSocket.Server,
	debug = require('debug')('my-application');

var
	logger = require('morgan'),
	favicon = require('static-favicon'),
	bodyParser = require('body-parser'),
	cookieParser = require('cookie-parser');

var path = require('path');

var app = express();

app.set('port', process.env.PORT || 80);

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use(function(req, res, next) {
	var err = new Error('Not Found');
	err.status = 404;
	next(err);
});

if(app.get('env') === 'development') {
	app.use(function(err, req, res, next) {
		res.status(err.status || 500);
		res.json({ message: err.message, error: err });
	});
}

app.use(function(err, req, res, next) {
	res.status(err.status || 500);
	res.json({ message: err.message, error: {} });
});

var server = app.listen(app.get('port'), function() {
	debug('Express server listening on port ' + server.address().port);
});

var wsServer = new WebSocketServer({ server : server });

var clients = [];
wsServer.on('connection', function(ws) {
	console.log('connection')
	ws.on('error', function() {
		console.log(arguments)
	})
	ws.on('message', function(message) {
		if(message === 'subscribe') {
			console.log('subscribe')
			clients.push(ws);
		}
		else {
			for(var i = 0; i < clients.length; i++) {
				if(clients[i].readyState === WebSocket.OPEN) {
					clients[i].send(message);
				}
			}
		}
	});
});
