loadScript = (src, callback) ->
  e = document.createElement('script')
  e.type = 'text/javascript'
  e.src = src
  if callback
    e.onloadDone = false
    e.onload = ->
      e.onloadDone = true
      callback()
    e.onReadystatechange = ->
      if e.readyState == 'loaded' and !e.onloadDone
        e.onloadDone = true
        callback()
  if typeof(e) != 'undefined'
    document.getElementsByTagName('head')[0].appendChild(e)

messages_buf = []

#load socket.io
loadScript 'https://cdnjs.cloudflare.com/ajax/libs/socket.io/0.9.16/socket.io.min.js', ->
  #receive message
  socket = io.connect("http://niconico-learning.herokuapp.com:80")
  socket.on 'new-message', (msg) ->
    messages_buf.push msg

#create canvas
canvas = document.createElement('canvas')
canvas.width = canvas.height = 500
canvas.style.left = canvas.style.top = '0px'
canvas.style.position = 'absolute'
document.body.appendChild(canvas)
context = canvas.getContext('2d')

messages = []
context.font = '20px Arial'
context.fillStyle = 'black'

#loop
width = canvas.width
height = canvas.height
setInterval (->
  context.clearRect(0, 0, width, height)

  for msg in messages_buf
    msg.x = width
    msg.y = 10 + height * Math.random() - 10
    msg.vx = -1 + (-4 * Math.random())
    msg.vy = 0
    msg.width = context.measureText(msg.content).width
    messages.push msg
  messages_buf = []

  remove_list = []
  for msg, i in messages
    context.fillText(msg.content, msg.x, msg.y)

    msg.x += msg.vx
    msg.y += msg.vy
    if msg.x + msg.width < 0
      remove_list.push i

  for index in remove_list
    messages.splice(index, 1)
  ), 1000 / 30