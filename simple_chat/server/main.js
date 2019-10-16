let app = require('express')();
let http = require('http').Server(app);
let io = require('socket.io')(http);
let port = 3000;

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){
  socket.on('chat message', function(msg){
    io.emit('chat message', msg);
		console.log('message: [' + msg + '] emitted.');
  });
});

http.listen(port, function(){
  console.log('listening on *:' + port);
});
