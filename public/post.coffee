$ ->
  socket = io.connect("http://#{location.host}")
  socket.on 'connect', ->
    socket.emit 'post-message', content: 'enter!'

  postMessage = ->
    socket.emit 'post-message', content: $('#message-input').val()
    $('#message-input').val('')

  $('#message-input').keypress (event) ->
    if event.keyCode == 13
      postMessage()

  $('#post-btn').click ->
    postMessage()