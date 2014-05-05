connect = require 'connect'
http = require 'http'
io = require('socket.io')

app = connect()
  .use(connect.static(__dirname + '/public'))

server = http.createServer(app).listen(process.env.PORT || 3000)

io = io.listen(server)
io.sockets.on 'connection', (socket) ->
  socket.emit 'new-message', { content: 'ready' }

  socket.on 'post-message', (msg) ->
    socket.broadcast.emit 'new-message', msg