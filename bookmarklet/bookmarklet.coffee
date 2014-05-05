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
  socket = io.connect("http://#{window.niconico_anywhere_host ? "niconico-learning.herokuapp.com:80"}")
  socket.on 'new-message', (msg) ->
    messages_buf.push msg

messages = []

#loop
wwidth = document.documentElement.clientWidth
wheight = document.documentElement.clientHeight
setInterval (->
  for msg in messages_buf
    element = document.createElement('div')
    element.style.position = 'absolute'
    element.textContent = msg.content
    document.body.appendChild element
    messages.push
      x: wwidth, y: 10 + wheight * Math.random() - 10
      vx: -1 + (-4 * Math.random()), vy: 0
      element: element
  messages_buf = []

  remove_list = []
  for msg, i in messages
    s = msg.element.style
    s.left = "#{msg.x}px"
    s.top = "#{msg.y}px"

    msg.x += msg.vx
    msg.y += msg.vy
    if msg.x + msg.element.clientWidth < 0
      remove_list.push [i, msg.element]

  for [index, element] in remove_list
    messages.splice(index, 1)
    element.parentNode.removeChild(element)

  ), 1000 / 30